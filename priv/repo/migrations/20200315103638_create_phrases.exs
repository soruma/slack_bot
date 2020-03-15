defmodule SlackBot.Repo.Migrations.CreatePhrases do
  use Ecto.Migration

  def change do
    create table(:phrases) do
      add :phrase, :string
    end
  end
end
