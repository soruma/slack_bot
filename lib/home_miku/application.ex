defmodule HomeMiku.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    Slack.Bot.start_link(HomeMiku.Slack.Rtm, [], System.get_env("SLACK_BOT_API_TOKEN"))

    children = [
      # Starts a worker by calling: HomeMiku.Worker.start_link(arg)
      # {HomeMiku.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HomeMiku.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
