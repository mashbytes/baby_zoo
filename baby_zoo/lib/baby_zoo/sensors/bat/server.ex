defmodule BabyZoo.Sensors.Bat.Server do
  @moduledoc """
  Listens for noise.
  """
  require Logger

  use GenServer

  alias ElixirALE.GPIO
  alias BabyZoo.Sensors.Bat.Impl

  @keeper Application.get_env(:zoo, :keeper)
  @input_pin Application.get_env(:zoo, :input_pin, 20)

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
    new_state = Impl.determine_state(state, direction)
    @keeper.sensor_state_changed({:type, sound, :state, new_state)
    { :noreply, new_state }
  end

  def handle_cast(:falling, state) do
    new_state = Impl.determine_state(state, direction)
    @keeper.sensor_state_changed({:type, sound, :state, new_state)
    { :noreply, new_state }
  end

end
