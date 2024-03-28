defmodule Ecomrecommendations.EmbeddingRecommendations do
  @behaviour Ecomrecommendations.RecommendationBehavior

  import Ecto.Query
  alias Ecomrecommendations.Repo
  alias Ecomrecommendations.EmbeddedProduct
  alias Ecomrecommendations.Events

  @description_weight 0.25
  @brand_name_weight 0.25
  @flower_type_weight 0.25
  @composition_weight 0.25

  @embeddings_model "distilbert-base-uncased"

  def get_similar_products(product_id) when is_binary(product_id) do
    with [target | _] <- get_product_embeddings(product_id) do
      total_similarity = get_total_similarity_query(target, [get_max_composition_distance(target)])

      (
        from pe in EmbeddedProduct,
        select: pe.external_id,
        where: pe.external_id != ^product_id,
        order_by: ^total_similarity,
        limit: 10
      )
      |> Repo.all()
    end
  end

  def get_user_recommendations(user_id) when is_binary(user_id) do

    user_products = get_last_interacted_products(user_id)

    attrs =
      user_products
      |> join_product_data()
      |> generate_embeddings()

    composition_distances = Enum.map(user_products, &get_max_composition_distance(&1))
    product_ids = Enum.map(user_products, fn product -> product.external_id end)

    total_similarity = get_total_similarity_query(attrs, composition_distances)

    (
      from pe in EmbeddedProduct,
      select: pe.external_id,
      where: pe.external_id not in ^product_ids,
      order_by: ^total_similarity,
      limit: 10
    )
    |> Repo.all()
  end

  defp get_total_similarity_query(attrs, composition_distances) do
    total_similarity =
      dynamic([pe], 0)
      |> get_attrs_similarity_query(attrs)
      |> get_composition_similarity_query(composition_distances)

    dynamic([pe], ^total_similarity + fragment("0 DESC"))
  end

  defp get_attrs_similarity_query(initial_dynamic, attrs) do
    [:description, :brand_name, :flower_type]
    |> Enum.reduce(initial_dynamic, fn field, dynamic ->
      case field do
        :description ->
          dynamic([pe], ^dynamic + fragment("pgml.cosine_similarity(?, ?) * ?", pe.description, ^attrs.description, ^@description_weight))
        :brand_name ->
          dynamic([pe], ^dynamic + fragment("pgml.cosine_similarity(?, ?) * ?", pe.brand_name, ^attrs.brand_name, ^@brand_name_weight))
        :flower_type ->
          dynamic([pe], ^dynamic + fragment("pgml.cosine_similarity(?, ?) * ?", pe.flower_type, ^attrs.flower_type, ^@flower_type_weight))
      end
    end)
  end

  defp get_composition_similarity_query(initial_dynamic, compositions) do
    compositions
    |> Enum.reduce(initial_dynamic, fn {target, max_distance}, dynamic ->
      dynamic([pe], ^dynamic + fragment("(1 - ((? <-> ?) / ?)) * ?", pe.composition, ^target.composition, ^max_distance, @composition_weight))
    end)
  end

  defp get_product_embeddings(product_id) do
    (
      from embedding in EmbeddedProduct,
      where: embedding.external_id == ^product_id,
      select: %{
        description: embedding.description,
        brand_name: embedding.brand_name,
        flower_type: embedding.flower_type,
        composition: embedding.composition
      }
    )
    |> Repo.all()
  end

  defp get_max_composition_distance(target) do
    {max_distance} =
      (
        from pe in EmbeddedProduct,
        select: {
          fragment("MAX(? <-> ?)", pe.composition, ^target.composition)
        }
      )
      |> Repo.one()

      if max_distance == 0 do
        {target, 1}
      else
        {target, max_distance}
      end

  end

  defp get_last_interacted_products(user_id) do
    # com o user_id ir buscar os últimos produtos da tabela events (ordenados por inserted_at) e devolver a estrutura abaixo (external_id, description, brand_anme, etc)
    product_ids =
      user_id
      |> Events.get_latest_event_for_user()
      |> Enum.map(fn event -> event.product_id end)

    ["BD001", "TW001", "SD001", "GSC001", "WW001"]
    |> Enum.map(fn external_id -> %{
      external_id: external_id,
      description: "Test Description",
      brand_name: "Test Brand Name",
      flower_type: "Test Flower Type",
      composition: [3.14, 2.718, 1.618, 4.669, 0.577, 1.732, 2.302, 1.414, 2.718]
    } end)
  end

  defp join_product_data(products) do
    products
    |> Enum.reduce(%{
      description: "",
      brand_name: "",
      flower_type: ""
    }, fn p, acc ->
      %{
        description: acc.description <> p.description <> ", ",
        brand_name: acc.brand_name <> p.brand_name <> ", ",
        flower_type: acc.flower_type <> p.flower_type <> ", "
      }
    end)
  end

  defp generate_embeddings(target) do
    (
      from pe in EmbeddedProduct,
      select: %{
        description: fragment("pgml.embed(?, ?)", ^@embeddings_model, ^target.description),
        brand_name: fragment("pgml.embed(?, ?)", ^@embeddings_model, ^target.brand_name),
        flower_type: fragment("pgml.embed(?, ?)", ^@embeddings_model, ^target.flower_type),
      },
      limit: 1
    )
    |> Repo.one()
  end
end
