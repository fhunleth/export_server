defmodule ExportServer.Worker do
  use GenServer

  def start_link(name, command) do
    GenServer.start_link(__MODULE__, command, name: name)
  end

  # GenServer implementation
  def init(command) do
    Process.flag(:trap_exit, true)
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
    Port.close(port)
  end

end
