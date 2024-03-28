defmodule Ecomrecommendations.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :type, :string
    field :user_id, :string
    field :product_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:type, :user_id, :product_id])
    |> validate_required([:type, :user_id, :product_id])
  end
end
