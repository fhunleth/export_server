defmodule ExportServer do
  use Application

  # See http://elixir-lang.org/docs/stable/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define the worker processes. 
    children = [
      worker(ExportServer.Worker, [:service_a, "priv/service_a"], id: :service_a),
      worker(ExportServer.Worker, [:service_b, "priv/service_b"], id: :service_b)
    ]

    # Start the supervisor and automatically restart the workers
    # unless they crash 2 times in 5 seconds.
    opts = [strategy: :one_for_one, max_restarts: 2, max_seconds: 5, name: ExportServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
