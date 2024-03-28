defmodule Ecomrecommendations.Repo.Migrations.CreateProductEmbeddings do
  use Ecto.Migration

  def change do
    create table(:product_embeddings) do
      add :description, {:array, :float}
      add :brand_name, {:array, :float}
      add :flower_type, {:array, :float}
      add :composition, :vector, size: 9

      add :external_id, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:product_embeddings, [:external_id])
  end
end
