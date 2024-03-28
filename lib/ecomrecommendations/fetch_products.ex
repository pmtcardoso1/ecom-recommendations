defmodule Ecomrecommendations.FetchProducts do
  use GenServer
  alias Ecomrecommendations.ProductFieldRefiner
  alias HTTPoison.Response
  alias Ecomrecommendations.Products

  @store_id "6e797121-e8f5-41fa-b688-355fcca8f630"
  @store_url "https://api.tymber.io/api/v1/products/"

    def start_link(_) do
      GenServer.start_link(__MODULE__, %{})
    end

    @impl true
    def init(_) do
      schedule_api_call()

      {:ok, nil}
    end

    @impl true
    def handle_info(:api_call, _) do
      case call_api(0, []) do
        {:ok, nil} ->
          IO.puts("End of Fetching")
        {:error, reason} ->
          handle_error(reason)
      end

      schedule_api_call()
      {:noreply, nil}
    end

    defp call_api(offset, products) do
      headers = [{"X-store", @store_id}]
      url = build_url(offset)
      IO.puts("Fetching #{url}")
      case HTTPoison.get(url, headers) do
        {:ok, %Response{status_code: 200, body: body}} ->
          meta =
            body
            |> Jason.decode!()
            |> Map.get("meta", %{})
          total_count = meta |> Map.get("total_count", 0)
          new_products = body |> Jason.decode!() |> Map.get("data", %{})
          total_products = new_products ++ products
           if(offset < total_count) do
             new_offset = offset + 20
             call_api(new_offset, total_products)
           else
            handle_products(total_products)
            {:ok, nil}
           end
        {:ok, %Response{status_code: _status_code}} ->
          {:error, :non_200_response}
        {:error, reason} ->
          {:error, reason}
      end
    end

    defp handle_products(total_products) do
      total_products
      |> ProductFieldRefiner.filter_fields
      |> Enum.each(&Products.insert/1)

      #Products.insert_embeddings_for_products()

      total_products
  end

    defp handle_error(reason) do
      IO.puts("Error occurred: #{inspect(reason)}")
    end

    defp build_url(offset) do
      "#{@store_url}?offset=#{offset}&limit=20&delivery_type=pickup"
    end

    defp schedule_api_call() do
      IO.puts("Scheduled next API call")
      Process.send_after(self(), :api_call, 24 * 60 * 60 * 1000)
    end
  end
