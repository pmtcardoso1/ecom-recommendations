defmodule Ecomrecommendations.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :description, :string
    field :composition, Pgvector.Ecto.Vector
    field :flower_type, :string
    field :category_name, :string
    field :brand_name, :string

    field :external_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :composition, :flower_type, :category_name, :brand_name, :external_id])
    |> validate_required([:name, :description, :composition, :flower_type, :category_name, :brand_name, :external_id])
    |> unique_constraint(:external_id)
  end
end
