defmodule BabyZoo.Bat do
  @moduledoc """
  Listens for noise every X period.
  """
  use GenServer

  require Logger

  alias ElixirALE.GPIO

  @interval Application.get_env(:bat, :read_interval, 2000)
  @input_pin Application.get_env(:bat, :input_pin, 20)

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(state) do
    Process.send(self(), { :listen_forever })

    {:ok, state}
  end

  def handle_info({ :listen_forever }, state) do
    {:ok, input_pid} = GPIO.start_link(@input_pin, :input)
    spawn(fn -> listen_forever(input_pid) end)
  end

  # def start(_type, _args) do
  #
  #   Logger.info("Starting pin #{@input_pin} as input, reading every #{@interval}")
  #   {:ok, input_pid} = GPIO.start_link(@input_pin, :input)
  #   spawn(fn -> listen_forever(input_pid) end)
  #
  #   pid = self()
  #   Keeper.register_sensor(pid)
  #
  #   {:ok, pid}
  #
  # end

  defp listen_forever(input_pid) do
    # Start listening for interrupts on rising and falling edges
    GPIO.set_int(input_pid, :both)
    listen_loop()
  end

  defp listen_loop() do
    # Infinite loop receiving interrupts from gpio
    receive do

      {:gpio_interrupt, pin, direction} ->
        process_noise_signal(direction)

    end

    listen_loop()
  end

  defp process_noise_signal(:rising) do
    Logger.debug("Received rising noise event")
    ZooKeeper.warning()
  end

  defp process_noise_signal(:falling) do
    Logger.debug("Received falling noise event")
    ZooKeeper.ok(self())
  end

end
