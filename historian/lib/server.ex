defmodule BabyZoo.Historian.Server do

  require Logger

  use GenServer

  alias BabyZoo.Historian.Impl

  def init(entries) do
    {:ok, entries}
  end

  def handle_cast({:record_latest_state, name, state}, entries) do
    new_entries = Impl.record_entry(name, state, entries)
    Logger.debug("Updated entries to #{inspect entries}")
    {:noreply, new_entries}
  end

end
