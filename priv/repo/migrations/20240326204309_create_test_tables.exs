defmodule Ecomrecommendations.Repo.Migrations.CreateTestTables do
  use Ecto.Migration

  def change do
    create table(:test_tables) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
