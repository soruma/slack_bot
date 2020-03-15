import Config

config :slack_bot, SlackBot.Repo,
  database: "slack_bot_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :slack_bot, ecto_repos: [SlackBot.Repo]

import_config "#{Mix.env}.exs"
