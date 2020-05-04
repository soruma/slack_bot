import Config

config :gettext, :default_locale, "ja"

config :slack_bot, SlackBot.Repo,
  database: "slack_bot_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
