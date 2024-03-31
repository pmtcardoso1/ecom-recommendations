defmodule EcomrecommendationsWeb.RecommendationController do
  use EcomrecommendationsWeb, :controller
  alias Ecomrecommendations.GraphRecommendations
  alias Ecomrecommendations.EmbeddingRecommendations
  alias EcomrecommendationsWeb.EventJSON

  def index(conn, %{"product_id" => product_id}) do
    with recommendations <- GraphRecommendations.get_bought_together_recommendations(product_id) do
      conn
      |> put_view(json: EventJSON, html: EventJSON)
      |> render(:index, data: recommendations)
    end
  end

  def index(conn,  %{"user_id" => user_id}) do
    with recommendations <- EmbeddingRecommendations.get_user_recommendations(user_id) do
      conn
      |> put_view(json: EventJSON, html: EventJSON)
      |> render(:index, data: recommendations)
    end
  end
end
