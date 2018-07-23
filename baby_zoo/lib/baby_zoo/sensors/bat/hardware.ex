defmodule BabyZoo.Sensors.Bat.Hardware do

  alias ElixirALE.GPIO

  @input_pin Application.get_env(:bat, :input_pin, 20)

  def start_link do
    {:ok, input_pid} = GPIO.start_link(@input_pin, :input)
    spawn(fn -> listen_forever(input_pid) end)
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


end
