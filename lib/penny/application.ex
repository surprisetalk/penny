defmodule Penny.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Penny.Worker.start_link(arg1, arg2, arg3)
      # worker(Penny.Worker, [arg1, arg2, arg3]),
      worker(Mongo, [[name: :mongo, database: "penny"]]),
      Plug.Adapters.Cowboy.child_spec(:http, Penny.Api, [], [
            dispatch: dispatch
          ])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Penny.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {
        :_,
        [
          {"/ws", Penny.Socket, []},
          {:_, Plug.Adapters,Cowboy.Handler, {Penny.Api, []}}
        ]
      }
    ]

  end
