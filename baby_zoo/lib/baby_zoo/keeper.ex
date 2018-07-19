defmodule BabyZoo.Keeper do
  @moduledoc """
  Documentation for Keeper.
  """
  use GenServer

  require Logger

  def start do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def ok(sensor) do
    GenServer.cast(__MODULE__, {:ok, sensor})
  end

  def warning(sensor) do
    GenServer.cast(__MODULE__, {:warning, sensor})
  end

  def critical(sensor) do
    GenServer.cast(__MODULE__, {:critical, sensor})
  end

  def handle_cast({:ldr_light, ldr, time}, counters) do
    Logger.debug("#{ldr[:name]} is lit (#{counters[ldr[:name]]}x). Rise: #{time}us")

    # Trigger notification after receiving three notifications in a row
    if counters[ldr[:name]] == 2, do: send_notification(ldr)

    {:noreply, Map.update(counters, ldr[:name], 1, &(&1 + 1))}
  end

  def handle_cast({:ldr_dark, ldr}, counters) do
    Logger.debug("#{ldr[:name]} is dark")

    {:noreply, Map.put(counters, ldr[:name], 0)}
  end

  # def listen() do
  #   receive do
  #
  #     { :register_sensor, client_pid } ->
  #       Logger.debug("registering #{inspect client_pid}")
  #       # send client_pid { :registered { :keeper_pid: self() } }
  #
  #     { :update, { pid" => pid, "value" => value } } ->
  #       Logger.debug("updating for #{inspect pid}")
  #
  #   end
  #   listen()
  # end
end
