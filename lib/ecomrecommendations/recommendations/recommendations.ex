defmodule Ecomrecommendations.EmbeddingRecommendations do
  @behaviour Ecomrecommendations.RecommendationBehavior

  import Ecto.Query
  alias Ecomrecommendations.Repo
  alias Ecomrecommendations.EmbeddedProduct

  @description_weight 0.25
  @brand_name_weight 0.25
  @flower_type_weight 0.25
  @composition_weight 0.25

  def get_similar_product(product_id) when is_binary(product_id) do
    with [target | _] <- get_product_embeddings(product_id) do
      (
        from pe in EmbeddedProduct,
        select: %{
          external_id: pe.external_id,
          total_similarity: (
            fragment("pgml.cosine_similarity(?, ?) * ?", pe.description, ^target.description, ^@description_weight) +
            fragment("pgml.cosine_similarity(?, ?) * ?", pe.brand_name, ^target.brand_name, ^@brand_name_weight)+
            fragment("pgml.cosine_similarity(?, ?) * ?", pe.flower_type, ^target.flower_type, ^@flower_type_weight)+
            fragment("(1 - (? <-> ?) / ?) * ? as total_similarity", pe.composition, ^target.composition, ^get_max_composition_distance(target), ^@composition_weight)
          )
        },
        where: pe.external_id != ^product_id,
        order_by: fragment("total_similarity DESC"),
        limit: 10
      )
      |> Repo.all()
    end
  end

  @spec get_user_recommendations(binary()) :: [%{product_id: <<_::32>>}, ...]
  def get_user_recommendations(user_id) when is_binary(user_id) do
    [
      %{product_id: "AAAA"},
      %{product_id: "BBBB"},
      %{product_id: "CCCC"},
    ]
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

    max_distance
  end
end
