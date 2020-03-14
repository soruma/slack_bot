defmodule SlackBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    Slack.Bot.start_link(SlackBot.Slack.Rtm, [], System.get_env("SLACK_BOT_API_TOKEN"))

    children = [
      # Starts a worker by calling: SlackBot.Worker.start_link(arg)
      # {SlackBot.Worker, arg}
      {Plug.Cowboy, scheme: :http, plug: SlackBot.Web.Router, options: [port: 8181]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SlackBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
