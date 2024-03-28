defmodule Ecomrecommendations.ProductFieldRefiner do

  def filter_fields(productList) do
    IO.puts("Filtering fields...")
    extracted_fields = Enum.map(productList,
    fn %{"attributes" =>
    %{"name" => name, "description" => description, "composition" => composition, "store_url" => store_url, "external_id" => external_id, "flower_type" => flower_type},
    "relationships" => %{"category" => %{"data" => %{"id" => category}}}}
    -> %{"name" => name, "description" => description, "composition" => extract_composition(composition), "brand_name" => extract_brand(store_url), "category_name" => extract_category(store_url), "external_id" => external_id, "flower_type" => flower_type, "category" => category} end)
    IO.inspect(extracted_fields)
  end

  defp extract_composition(nil), do: nil
  defp extract_composition(composition), do: Map.values(composition)

  defp extract_brand(url) do
    parts = String.split(url, "/")

    case Enum.at(parts, 5) do
      value when is_binary(value) ->
      value
      _ ->
        {:error, "URL does not have values in positions 5 and 6"}
    end
  end

  defp extract_category(url) do
    parts = String.split(url, "/")

    case Enum.at(parts, 6) do
      value when is_binary(value) ->
      value
      _ ->
        {:error, "URL does not have values in positions 5 and 6"}
    end
  end

end
