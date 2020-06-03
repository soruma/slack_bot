defmodule SlackBot.Schema.Phrase do
  @moduledoc false

  use Ecto.Schema

  schema "phrases" do
    field(:phrase, :string)
  end

  def changeset(phrase, params \\ %{}) do
    phrase
    |> Ecto.Changeset.cast(params, [:phrase])
    |> Ecto.Changeset.validate_required([:phrase])
  end
end
