defmodule Ecomrecommendations.Products do
  alias Ecomrecommendations.{Product, EmbeddedProduct, Repo}
  import Ecto.Query

  @embedding_module "distilbert-base-uncased"

  def insert(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def insert_embeddings_for_products do
    get_product_embeddings()
    |> Enum.each(&insert_embedding/1)
  end

  def get_products_by_ids(product_ids \\ []) do
    (
      from p in Product,
      where: p.external_id in ^product_ids
    )
    |> Repo.all()
  end

  defp insert_embedding(attrs) do
    %EmbeddedProduct{}
    |> EmbeddedProduct.changeset(attrs)
    |> Repo.insert()
  end

  defp get_product_embeddings do
    (
      from p in Product,
      select: %{
        id: p.id,
        description: fragment("pgml.embed(?, coalesce(?, ?, ''))", ^@embedding_module, p.description, p.name),
        brand_name: fragment("pgml.embed(?, coalesce(?, ''))", ^@embedding_module, p.brand_name),
        flower_type: fragment("pgml.embed(?, coalesce(?, ''))", ^@embedding_module, p.flower_type),
        composition: p.composition,
        external_id: p.external_id,
      }
    )
    |> Repo.all(timeout: :infinity)
  end
end
