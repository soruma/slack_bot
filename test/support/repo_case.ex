defmodule SlackBot.RepoCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      alias SlackBot.Repo

      import Ecto
      import Ecto.Query
      import SlackBot.RepoCase
    end
  end

  setup tags do
    alias Ecto.Adapters.SQL.Sandbox

    :ok = Sandbox.checkout(SlackBot.Repo)

    unless tags[:async] do
      Sandbox.mode(SlackBot.Repo, {:shared, self()})
    end

    :ok
  end
end
