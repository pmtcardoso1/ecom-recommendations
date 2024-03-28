defmodule Ecomrecommendations.RecommendationBehavior do
  @callback get_similar_products(product_id :: String.t()) :: [map()]
  @callback get_user_recommendations(user_id :: String.t()) :: [map()]
end
