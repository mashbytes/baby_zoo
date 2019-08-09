defmodule Device.Ticker do
  
  @callback snapshot() :: Device.State
  @callback topic() :: String.t

  defmacro __using__(_) do
    quote do
      @behaviour Device.Ticker

      use GenServer
      require Logger

      @server __MODULE__

      def start_link(_) do
        GenServer.start_link(@server, nil, name: @server)
      end

      def init(_) do
        schedule_initial_job()
        {:ok, nil}
      end

      def handle_info(:tick, state) do
        snapshot = snapshot()
        topic = topic()
        Logger.debug("Ticking with topic [#{topic}] state #{snapshot}")
        Device.Publisher.publish(topic, @server, snapshot)
        schedule_next_job()
        {:noreply, state}
      end

      defp schedule_initial_job() do
        Process.send_after(self(), :tick, 1_000) # In 1 seconds
      end

      defp schedule_next_job() do
        Process.send_after(self(), :tick, 1_000) # In 1 seconds
      end
    end
  end
end