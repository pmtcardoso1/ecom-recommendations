defmodule Ecomrecommendations.EmbeddedProduct do
  use Ecto.Schema
  import Ecto.Changeset

  schema "product_embeddings" do
    field :description, {:array, :float}
    field :brand_name, {:array, :float}
    field :flower_type, {:array, :float}
    field :composition, Pgvector.Ecto.Vector

    field :external_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(embedded_product, attrs) do
    embedded_product
    |> cast(attrs, [:description, :composition, :flower_type, :brand_name, :external_id])
    |> validate_required([])
    |> unique_constraint(:external_id)
  end
end
