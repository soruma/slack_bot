defmodule HomeMiku.Web.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/ping" do
    conn
    |> put_resp_content_type("application/json")
    |> resp(:ok, Poison.encode!(%{message: "Pong!"}))
    |> send_resp
  end

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:not_found, Poison.encode!(%{message: "Oops!"}))
  end
end
