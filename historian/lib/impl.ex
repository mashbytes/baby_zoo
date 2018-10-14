defmodule BabyZoo.Historian.Impl do

  require Logger

  def record_entry(name, state, entries) do
    Map.update(entries, name, BabyZoo.Historian.Entry.new(name, state), fn entry ->
      %{entry | last_updated: DateTime.utc_now(), states: [state|entry.states]}
    end)
  end


end

defmodule BabyZoo.Historian.Entry do

  defstruct [:name, :last_updated, :states]

  def new(name, initial_state) do
    %BabyZoo.Historian.Entry{name: name, last_updated: DateTime.utc_now(), states: [initial_state]}
  end

end
