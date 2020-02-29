defmodule HomeMiku.Web.Router do
  use Plug.Router

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]

  plug :match
  plug :dispatch

  get "/ping" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:ok, Poison.encode!(%{message: "Pong!"}))
  end

  get "/echo" do
    conn
    |> put_resp_content_type("application/json")
    |> echo
    |> send_resp(:ok, Poison.encode!(conn.params))
  end

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:not_found, Poison.encode!(%{message: "Oops!"}))
  end

  def echo(conn) do
    case Map.fetch(conn.params, "message") do
      {:ok, message} -> Slack.Web.Chat.post_message("bot-sandbox", message, %{token: System.get_env("SLACK_BOT_API_TOKEN"), as_user: true})
      _ -> {:ok}
    end

    conn
  end
end
