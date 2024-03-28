defmodule Ecomrecommendations.Products do
  alias Ecomrecommendations.{Product, Repo}

  def insert(attrs\\%{}) do
    IO.inspect(attrs)
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
    |> IO.inspect()
  end
end
