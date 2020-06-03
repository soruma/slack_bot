import Config

config :slack_bot, ecto_repos: [SlackBot.Repo]

import_config "#{Mix.env()}.exs"
