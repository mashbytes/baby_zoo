defmodule Skippy.Sound do
  
  require Logger

  @server __MODULE__.Server
  @registry __MODULE__.Registry

  def subscribe() do
    @registry.subscribe
  end

end