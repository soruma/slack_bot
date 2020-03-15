defmodule SlackBot.Repo do
  use Ecto.Repo,
    otp_app: :slack_bot,
    adapter: Ecto.Adapters.Postgres
end
