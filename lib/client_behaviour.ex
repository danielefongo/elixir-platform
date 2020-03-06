defmodule Parallel.ClientBehaviour do
  @callback init() :: new_state :: term
  @callback handle_call(command :: term, state :: term) :: {result :: term, new_state :: term}
  @callback handle_cast(command :: term, state :: term) :: {:noreply, new_state :: term}
end
