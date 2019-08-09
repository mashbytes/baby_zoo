defmodule HubWeb.Listener do

  def child_spec(_) do
    Supervisor.Spec.worker(__MODULE__, [])
  end

  def start_link() do
    DeviceBus.subscribe()
  end

end