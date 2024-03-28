defmodule EcomrecommendationsWeb.EventController do
  use EcomrecommendationsWeb, :controller
  alias Ecomrecommendations.Events
  alias EcomrecommendationsWeb.EventJSON

  def create(conn, event_params) do
    with {:ok, event} <- Events.insert(event_params) do
      conn
      |> put_view(json: EventJSON, html: EventJSON)
      |> render(:index, data: event)
    end
  end
end
