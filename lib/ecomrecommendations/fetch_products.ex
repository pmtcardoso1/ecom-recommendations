defmodule Ecomrecommendations.FetchProducts do
  use GenServer
  alias HTTPoison.Response

  @store_id "6e797121-e8f5-41fa-b688-355fcca8f630"
  @store_url "https://api.tymber.io/api/v1/products/?limit=20&delivery_type=pickup"

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(_) do
    # Schedule work to be performed on start
    IO.puts("Hello")
    schedule_api_call()

    {:ok, nil}
  end

  @impl true
  def handle_info(:api_call, _) do
    case call_api() do
      :ok -> IO.puts("Ok")
      {:ok, response} ->
        handle_response(response)
      {:error, reason} ->
        handle_error(reason)
    end

    schedule_api_call()
    {:noreply, nil}
  end

  defp call_api do
    headers = [
      {"X-store", @store_id}
    ]
    IO.puts("Fetching")
    HTTPoison.get(@store_url, headers)
  end

  defp handle_response(%Response{status_code: 200, body: body}) do
    IO.puts("Received response: #{body}")
  end

  defp handle_response(%Response{status_code: status_code}) do
    IO.puts("Received non-200 response: #{status_code}")
  end

  defp handle_error(reason) do
    IO.puts("Error occurred: #{inspect(reason)}")
  end

  defp schedule_api_call do
    IO.puts("Scheduled")
    Process.send_after(self(), :api_call, 5 * 60 * 1000)
  end
end
