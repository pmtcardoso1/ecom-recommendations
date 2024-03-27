defmodule Ecomrecommendations.FetchProducts do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    # Schedule work to be performed on start
    IO.puts("Hello")
    schedule_work()

    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    # Do the desired work here
    # ...

    # Reschedule once more
    IO.puts("Handling...")
    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    # We schedule the work to happen in 2 hours (written in milliseconds).
    # Alternatively, one might write :timer.hours(2)
    IO.puts("Scheduled")
    Process.send_after(self(), :work, 1 * 1000)
  end
end
