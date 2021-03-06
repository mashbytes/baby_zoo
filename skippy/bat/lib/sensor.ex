defmodule Bat.Sensor do
    
  use GenServer

  require Logger

  @input_pin Application.get_env(:skippy, :sound_input_pin, 4)
  @timeout Application.get_env(:skippy, :sound_timout, 2000)
  @name __MODULE__

  def start_link(state) do
    GenServer.start_link(@name, state, name: @name)
  end

  def init(_) do
    Logger.debug("Starting hardware on pin #{@input_pin}")
    {:ok, pid} = Circuits.GPIO.open(@input_pin, :input)
    :ok = Circuits.GPIO.set_interrupts(pid, :rising)
    {:ok, %{gpio: pid, state: Device.State.new(:inactive, DateTime.utc_now())}}
  end

  def handle_info({:circuits_gpio, @input_pin, timestamp, 1}, state) do
    # Logger.debug("Received high signal on #{@input_pin}, timestamp, #{timestamp}")
    active = Device.State.new(:active, timestamp)
    updated_state = %{state | state: active}
    {:noreply, updated_state, @timeout}
  end

  def handle_info(:timeout, state) do
    inactive_state = Device.State.new(:inactive, DateTime.utc_now())
    Logger.debug("Timeout occurred, setting state to [#{inactive_state}]")
    updated_state = %{state | state: inactive_state}
    {:noreply, updated_state}    
  end

  def handle_call(:snapshot, _, state) do
    Logger.debug("Fetching snapshot [#{Map.get(state, :state)}]")
    snapshot = Map.get(state, :state)
    {:reply, snapshot, state}
  end

  def snapshot() do
    GenServer.call(@name, :snapshot)
  end

end
