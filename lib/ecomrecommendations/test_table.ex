defmodule Ecomrecommendations.TestTable do
  use Ecto.Schema
  import Ecto.Changeset

  schema "test_tables" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(test_table, attrs) do
    test_table
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
