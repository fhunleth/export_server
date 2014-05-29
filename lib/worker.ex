defmodule ExportServer.Worker do
  use GenServer

  def start_link(name, command) do
    GenServer.start_link(__MODULE__, command, name: name)
  end

  # GenServer implementation
  def init(command) do
    # If the service exits, have Elixir send a :EXIT message
    # to us.
    Process.flag(:trap_exit, true)

    # Spawn the service
    port = Port.open({:spawn, command}, [:stream, {:line, 79}])
    {:ok, [port]}
  end

  def handle_info({:EXIT, _port, reason}, state) do
    {:stop, {:port_terminated, reason}, state}
  end
  def handle_info({_port, {:data, {:eol, []}}}, state) do
    {:stop, :port_closed, state}
  end

  def terminate({:port_terminated, _reason}, _state) do
    :ok
  end
  def terminate(_reason, [port]) do
    # If the Worker process terminates for any reason other than
    # :port_terminated (see above), close the port and hence kill
    # the service.
    Port.close(port)
  end

end
