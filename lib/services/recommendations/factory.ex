defmodule Ecomrecommendations.RecommendationFactory do
  @embedding_recommendations "embedding_recommendations"
  @implementations [
    {@embedding_recommendations, Ecomrecommendations.EmbeddingRecommendations}
  ]

  @allowed_types [@embedding_recommendations]

  def get_provider(implementation) when implementation in @allowed_types do
    {_, implementation} = Enum.find(@implementations, fn {key, _} -> key == implementation end)
    case implementation do
      nil -> raise ArgumentError, "No implementation found"
      _ -> implementation
    end
  end

  def get_provider(_) do
    raise ArgumentError, "Type not allowed"
  end
end
