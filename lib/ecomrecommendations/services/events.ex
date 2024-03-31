defmodule Ecomrecommendations.Events do
  alias Ecomrecommendations.{Event, Repo}
  alias Ecomrecommendations.Neo4jApi
  import Ecto.Query

  def insert(attrs \\ %{})
  def insert(%{ "type" => "order_placed", "user_id" => user_id, "products" => products }) do

    buyer_props = %{"buyer_id" => user_id}
    Neo4jApi.create_buyer_node_if_not_exists(%{"buyer_id" => user_id})
    products
    |> Enum.each(fn p ->
      product_props = %{"product_id" => p["product_id"]}

      Neo4jApi.create_product_node_if_not_exists(%{"product_id" => p["product_id"]})
      Neo4jApi.create_or_update_bought_relation(buyer_props, product_props)
    end)

    create_or_update_bought_together_relations(products)
  end

  def insert(attrs) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  defp create_or_update_bought_together_relations([]) do
    []
  end
  defp create_or_update_bought_together_relations([_product]) do
    []
  end
  defp create_or_update_bought_together_relations([product | rest]) do
    product_props = %{"product_id" => product["product_id"]}
    rest
    |> Enum.each(fn other_product ->
      other_product_props = %{"product_id" => other_product["product_id"]}

      Neo4jApi.create_or_update_bought_together_relation(product_props, other_product_props)
    end)

    create_or_update_bought_together_relations(rest)
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
