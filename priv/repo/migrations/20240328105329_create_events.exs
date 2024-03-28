defmodule Ecomrecommendations.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :type, :string
      add :user_id, :string
      add :product_id, :string

      timestamps(type: :utc_datetime)
    end
  end
end
