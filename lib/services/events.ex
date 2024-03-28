defmodule Ecomrecommendations.Events do
  alias Ecomrecommendations.{Event, Repo}

  def insert(attrs \\%{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end
end
