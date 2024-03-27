defmodule Ecomrecommendations.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :description, :text
      add :flower_type, :string
      add :category_name, :string
      add :brand_name, :string
      add :external_id, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:products, [:external_id])
  end
end
