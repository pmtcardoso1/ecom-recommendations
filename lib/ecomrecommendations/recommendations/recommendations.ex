defmodule Ecomrecommendations.EmbeddingRecommendations do
  @behaviour Ecomrecommendations.RecommendationBehavior

  import Ecto.Query
  alias Ecomrecommendations.Repo

  def get_similar_product(product_id) when is_binary(product_id) do
    sql = "
      WITH query AS (
    SELECT pgml.embed('distilbert-base-uncased', 'An indica-dominant hybrid strain with earthy and pine flavors., A pure sativa strain with an uplifting effect.') AS d_embedding,
           pgml.embed('distilbert-base-uncased', 'sample brand, example brand') AS b_embedding,
           pgml.embed('distilbert-base-uncased', 'indica, sativa, hybrid') AS f_embedding,
           MAX(cannabis_products.composition <-> '[3.14, 2.718, 1.618, 4.669, 0.577, 1.732, 2.302, 1.414, 2.718]')  as max_distance_1,
           MAX(cannabis_products.composition <-> '[21.5,0.7,1.3,23,1.5,20,0.5,22,0.9]')  as max_distance_2
           from cannabis_products
)
SELECT description, brand_name, flower_type, composition,
       pgml.cosine_similarity(product_embeddings.description_embed, query.d_embedding) * 0.25 +
       pgml.cosine_similarity(product_embeddings.brand_name_embed, query.b_embedding) * 0.25 +
       pgml.cosine_similarity(product_embeddings.flower_type_embed, query.f_embedding) * 0.25 +
       (1 - (product_embeddings.composition <-> '[3.14, 2.718, 1.618, 4.669, 0.577, 1.732, 2.302, 1.414, 2.718]') / query.max_distance_1) * 0.125 +
       (1 - (product_embeddings.composition <-> '[21.5,0.7,1.3,23,1.5,20,0.5,22,0.9]') / query.max_distance_2) * 0.125 total_similarity
FROM product_embeddings, query
ORDER BY total_similarity DESC
LIMIT 50;"


    Repo.query(sql)
  end

  def get_user_recommendations(user_id) when is_binary(user_id) do
    [
      %{product_id: "AAAA"},
      %{product_id: "BBBB"},
      %{product_id: "CCCC"},
    ]
  end
end
