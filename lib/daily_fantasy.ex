defmodule DailyFantasy do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(DailyFantasy.PlayerRegistry, [])
    ]

    opts = [strategy: :one_for_one, name: DailyFantasy.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
