defmodule BabyZoo.Sensors.Bat.Hardware do

  require Logger

  alias ElixirALE.GPIO

  @input_pin Application.get_env(:bat, :input_pin, 20)

  def start_link(receiver_pid) do
    Logger.info("Starting hardware on pin #{@input_pin}, receiver pid #{receiver_pid}")
    {:ok, input_pid} = GPIO.start_link(@input_pin, :input)
    // TODO spawn link?
    spawn(fn -> listen_forever(input_pid, receiver_pid) end)
    { :ok, self() }
  end

  defp listen_forever(input_pid, receiver_pid) do
    # Start listening for interrupts on rising and falling edges
    GPIO.set_int(input_pid, :both)
    listen_loop(receiver_pid)
  end

  defp listen_loop(receiver_pid) do
    # Infinite loop receiving interrupts from gpio
    receive do
      {:gpio_interrupt, p, state} ->
        Logger.debug("Received #{state} event on pin #{p}")
        send receiver_pid, { :hardware_state, state }
    end

    listen_loop()
  end


end
