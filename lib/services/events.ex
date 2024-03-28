defmodule Ecomrecommendations.Events do
  alias Ecomrecommendations.{Event, Repo}
  import Ecto.Query

  def insert(attrs \\%{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  def get_latest_event_for_user(user_id) do
    (
      from e in Event,
      where: e.user_id == ^user_id,
      order_by: [desc: :inserted_at],
      limit: 5
    )
    |> Repo.all()
  end
end
