defmodule Device.Subscriber do

  @callback on_broadcast(topic :: :atom, device :: :atom, state :: Device.State.t) :: none()

  defmacro __using__(_) do
    quote do
      @behaviour Device.Subscriber
      @server __MODULE__

      use GenServer
      require Logger

      def start_link(arg) do
        Logger.info("Starting subscriber #{@server}")
        GenServer.start_link(@server, arg, name: @server)
      end

      def init(arg) do
        Process.send_after(self(), {:subscribe, arg}, 1_000)
        {:ok, arg}
      end

      def handle_info({:broadcast, topic, device, state}, g_state) do
        on_broadcast(topic, device, state)
        {:noreply, g_state}
      end

      def handle_info({:subscribe, topic}, g_state) do
        subscribe(topic)
        {:noreply, g_state}
      end

      defp subscribe(topic) do
        case Device.Registry.subscribe(topic) do
          {:ok, _} -> Logger.info("Successfully subscribed to [#{topic}]")
          {:error, _} -> retry_subscribe(topic)
        end
      end

      defp retry_subscribe(topic) do
        Logger.debug("Rescheduling subscribe to [#{topic}]")
        Process.send_after(self(), {:subscribe, topic}, 1_000) # In 60 seconds
      end

    end
  end

end