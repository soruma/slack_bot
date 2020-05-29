import Config

config :gettext, :default_locale, "en"

config :logger, level: :info

config :slack_bot, SlackBot.Repo,
  database: "#{System.get_env("DATABASE_NAME")}_test",
  username: System.get_env("DATABASE_USERNAME"),
  password: System.get_env("DATABASE_PASSWORD"),
  hostname: System.get_env("DATABASE_HOSTNAME"),
  pool: Ecto.Adapters.SQL.Sandbox
