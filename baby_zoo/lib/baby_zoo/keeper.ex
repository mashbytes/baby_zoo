defmodule BabyZoo.Keeper do
  @moduledoc """
  Documentation for Keeper.
  """
  use GenServer

  require Logger

  def start do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def ok(state) do
    GenServer.cast(__MODULE__, {:ok, state})
  end

  def warning(state) do
    GenServer.cast(__MODULE__, {:warning, state})
  end

  def critical(state) do
    GenServer.cast(__MODULE__, {:critical, state})
  end

  def handle_cast({:state, state}, _) do
    Logger.debug("#{:state} is #{state}")
    {:noreply, []}
  end

end
