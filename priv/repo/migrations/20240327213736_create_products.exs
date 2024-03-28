defmodule Ecomrecommendations.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :text
      add :description, :text
      add :composition, :vector, size: 9
      add :flower_type, :text
      add :category_name, :text
      add :brand_name, :text
      add :external_id, :text

      timestamps(type: :utc_datetime)
    end

    create unique_index(:products, [:external_id])
  end
end
