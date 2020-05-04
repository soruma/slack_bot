import Config

config :gettext, :default_locale, "en"

config :slack_bot, SlackBot.Repo,
  database: "slack_bot_repo_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
