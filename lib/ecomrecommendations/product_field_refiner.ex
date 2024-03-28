defmodule Ecomrecommendations.ProductFieldRefiner do



  #   field :composition, Pgvector.Ecto.Vector
  #   field :brand_name, :string

  def filter_fields(productList) do
    IO.puts("Filtering fields...")
    extracted_fields = Enum.map(productList, fn %{"attributes" => %{"name" => name, "description" => description, "composition" => composition, "external_id" => external_id, "flower_type" => flower_type}, "relationships" => %{"category" => %{"data" => %{"id" => category}}}} -> %{"name" => name, "description" => description, "composition" => Map.values(composition), "external_id" => external_id, "flower_type" => flower_type, "category" => category} end)
    IO.inspect(extracted_fields)
  end

end
