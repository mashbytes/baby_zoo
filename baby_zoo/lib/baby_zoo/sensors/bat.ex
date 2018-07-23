defmodule BabyZoo.Sensors.Bat do
  @moduledoc """
  Listens for noise.
  """
  require Logger

  use GenServer

  alias ElixirALE.GPIO
  alias BabyZoo.Keeper

  @input_pin Application.get_env(:bat, :input_pin, 20)

  def start_link do
      GenServer.start_link(__MODULE__, %{:value => 0}, name: __MODULE__)
  end

  def init(state) do
    Logger.info("Starting pin #{@input_pin} as input")
    {:ok, input_pid} = GPIO.start_link(@input_pin, :input)
    spawn(fn -> listen_forever(input_pid) end)
    {:ok, state}
  end

  defp listen_forever(input_pid) do
    # Start listening for interrupts on rising and falling edges
    GPIO.set_int(input_pid, :both)
    listen_loop()
  end

  defp listen_loop() do
    # Infinite loop receiving interrupts from gpio
    receive do
      {:gpio_interrupt, p, state} ->
        Logger.debug("Received #{state} event on pin #{p}")
        process_noise_signal(state)
    end

    listen_loop()
  end

  defp process_noise_signal(state) do
    Logger.debug("Received #{state} noise event")
    GenServer.cast(__MODULE__, state)
  end

  def handle_cast(:rising, state) do
    Keeper.ok()
    {:noreply, Map.put(state, :value, 0)}
  end

  def handle_cast(:falling, state) do
    old_value = state[:value]
    case old_value do
      x when x < 0 ->
        Keeper.critical()
      _ ->
        Keeper.warning()
    end

    {:noreply, Map.put(state, :value, -1)}

  end

end
