defmodule Ecomrecommendations.GraphRecommendations do
  alias Ecomrecommendations.Neo4jApi

  def get_user_recommendations(user_id) do
    with {:ok, result} <- Neo4jApi.get_frequently_bought_products(%{"buyer_id" => user_id}) do
      %{ "results" => [%{ "data" => entries }]} = result

      Enum.map(entries, fn %{"row" => [%{"product_id" => product_id}] } -> product_id end)
    end
  end

  def get_bought_together_recommendations(product_id) do
    with {:ok, result} <- Neo4jApi.get_bought_together_products(%{"product_id" => product_id}) do
      %{ "results" => [%{ "data" => entries }]} = result

      Enum.map(entries, fn %{"row" => [%{"product_id" => product_id}] } -> product_id end)
    end
  end
end
