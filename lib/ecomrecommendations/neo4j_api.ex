defmodule Ecomrecommendations.Neo4jApi do
  @base_url "http://3.82.193.22:7474/db/neo4j/tx/commit"

  def create_buyer_node_if_not_exists(properties) do
    %{
      statements: [
        %{
          statement: "MERGE (n:BUYER {buyer_id: $props.buyer_id}) RETURN n",
          parameters: %{"props" => properties}
        }
      ]
    }
    |> do_request()
  end

  def create_product_node_if_not_exists(properties) do
    %{
      statements: [
        %{
          statement: "MERGE (n:PRODUCT {product_id: $props.product_id}) RETURN n",
          parameters: %{"props" => properties}
        }
      ]
    }
    |> do_request()
  end

  def create_or_update_bought_relation(buyer_props, product_props) do
    %{
      statements: [
        %{
          statement: "MATCH (b:BUYER {buyer_id: $buyer_props.buyer_id}), (p:PRODUCT {product_id: $product_props.product_id}) MERGE (b)-[rel:BOUGHT]->(p) SET rel.freq = COALESCE(rel.freq, 0) + 1 RETURN b, p",
          parameters: %{
            "buyer_props" => buyer_props,
            "product_props" => product_props
          }
        }
      ]
    }
    |> do_request()
  end

  def create_or_update_bought_together_relation(product1_props, product2_props) do
    %{
      statements: [
        %{
          statement: "MATCH (p1:PRODUCT {product_id: $product1_props.product_id}), (p2:PRODUCT {product_id: $product2_props.product_id}) MERGE (p1)-[rel1:BOUGHT_TOGETHER]->(p2) SET rel1.freq = COALESCE(rel1.freq, 0) + 1 MERGE (p1)<-[rel2:BOUGHT_TOGETHER]-(p2) SET rel2.freq = COALESCE(rel2.freq, 0) + 1 RETURN p1, p2",
          parameters: %{
            "product1_props" => product1_props,
            "product2_props" => product2_props
          }
        }
      ]
    }
    |> do_request()
  end

  def get_bought_together_products(product_props) do
    %{
      statements: [
        %{
          statement: "MATCH (p1:PRODUCT {product_id: $product_props.product_id}) -[relation:BOUGHT_TOGETHER]-> (p2:PRODUCT) RETURN p2 ORDER BY relation.freq DESC",
          parameters: %{
            "product_props" => product_props
          }
        }
      ]
    }
    |> do_request()
  end

  def get_frequently_bought_products(buyer_props) do
    %{
      statements: [
        %{
          statement: "MATCH (buyer:BUYER {buyer_id: $buyer_props.buyer_id}) -[relation:BOUGHT]-> (p:PRODUCT) RETURN p ORDER BY relation.freq DESC",
          parameters: %{
            "buyer_props" => buyer_props
          }
        }
      ]
    }
    |> do_request()
  end

  defp do_request(query) do
    headers = [
      {"Content-Type", "application/json"},
      {"Accept", "application/json"},
      {"Authorization", "Basic " <> Base.encode64("neo4j:hackathon")}
    ]

    case HTTPoison.post(@base_url, Jason.encode!(query), headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:error, "HTTP error #{status_code}: #{body}"}
    end
  end
end
