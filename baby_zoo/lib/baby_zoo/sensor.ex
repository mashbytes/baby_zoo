defmodule BabyZoo.Sensor

  @doc "Subscribes to status updates"
  @callback subscribe(pid)

  @doc "Unsubscribes from status updates"
  @callback unsubscribe(pid)

end
