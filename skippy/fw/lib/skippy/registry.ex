defmodule Skippy.Registry do
  # Define behaviours which user modules have to implement, with type annotations
  @callback snapshot() :: Skippy.State.t

  # When you call use in your module, the __using__ macro is called.
  defmacro __using__(opts) do
    quote do
      @behaviour Skippy.Registry

      @name __MODULE__
      @topic __MODULE__.Topic
    
      def child_spec(init_arg) do
        default = %{
          id: __MODULE__,
          start: {__MODULE__, :start_link, [init_arg]}
        }

        Supervisor.child_spec(default, unquote(Macro.escape(opts)))
      end 

      def start_link(module, init_arg, options \\ []) when is_atom(module) and is_list(options) do
        Logger.info("Starting Registry named [#{@name}]")
        Registry.start_link(
          keys: :duplicate,
          name: @name,
          partitions: System.schedulers_online()
        )
      end

      def subscribe() do
        Logger.debug("Subscribing to registry named [#{@name}], topic [#{@topic}]")
        Registry.register(@name, @topic, [])    
      end

      def dispatch(state) do
        Logger.debug("Dispatching state [#{state}] to registry named [#{@name}], topic [#{@topic}]")
        Registry.dispatch(@name, @topic, fn entries ->
          for {pid, _} <- entries, do: send(pid, {:state_changed, state})
        end)
      end

      # def handle_state_change(state) do
        
      # end

      # defoverridable [handle_state_change: 1]

    end
  end
end
