# defprotocol Device do
#   @spec name(t) :: String.t
#   def name(type)
# end

defprotocol Device.Camera do
  @spec url(t) :: URI.t
  def url(type)
end

defprotocol Device.SoundSensor do

end

defprotocol Device.State.Streamable do
  @spec url(t) :: URI.t
  def url(type)
end

defmodule Device.State do

  @type level :: :ok | :warning | :critical | :unknown

  @enforce_keys [:level, :since]
  defstruct [:level, :since]

  @type t() :: %__MODULE__{
        level: level,
        since: DateTime.t()
      }

  @spec new(level, DateTime.t) :: Device.State.t
  def new(level, since) do
    %Device.State{level: level, since: since}
  end

end

defimpl String.Chars, for: Device.State do
  def to_string(%Device.State{level: level, since: since}) do
    "{#{level}, #{since}}"
  end
end
