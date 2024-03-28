defmodule Ecomrecommendations.ProductFieldRefiner do

  def filter_fields(productList) do
    IO.puts("Filtering fields...")
    Enum.map(productList,
    fn %{
      "id" => product_id,
      "attributes" =>
      %{
        "name" => name,
        "description" => description,
        "composition" => composition,
        "store_url" => store_url,
        "flower_type" => flower_type
      }
     }

    ->
      %{
        "name" => name || "",
         "description" => description || "",
         "composition" => extract_composition(composition),
         "brand_name" => extract_brand(store_url),
         "category_name" => extract_category(store_url),
         "external_id" => "#{product_id}" || "",
         "flower_type" => flower_type || "",
        }
   end)

  end

  defp extract_composition(nil), do: [0, 0, 0, 0, 0, 0, 0, 0, 0]
  defp extract_composition(composition), do: Map.values(composition)

  defp extract_brand(url) do
    parts = String.split(url, "/")

    case Enum.at(parts, 5) do
      value when is_binary(value) ->
      value
      _ ->
        ""
    end
  end

  defp extract_category(url) do
    parts = String.split(url, "/")

    case Enum.at(parts, 6) do
      value when is_binary(value) ->
      value
      _ ->
        ""
    end
  end

end
