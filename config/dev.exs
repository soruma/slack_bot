import Config

config :gettext, :default_locale, "ja"

config :logger, level: :info

config :slack_bot, SlackBot.Repo,
  database: "#{System.get_env("DATABASE_NAME")}_dev",
  username: System.get_env("DATABASE_USERNAME"),
  password: System.get_env("DATABASE_PASSWORD"),
  hostname: System.get_env("DATABASE_HOSTNAME")

config :slack_bot,
  api_token: System.get_env("SLACK_BOT_API_TOKEN")
