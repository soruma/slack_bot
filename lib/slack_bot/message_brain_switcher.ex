defmodule SlackBot.MessageBrain.Switcher do
  @moduledoc false

  @spec switch(String.t) :: module
  def switch(message) do
    [SlackBot.MessageBrain.AddMessage]
    |> Enum.find(SlackBot.MessageBrain.Nil,
                 fn(module) -> if(module.decide(message), do: module) end)
  end
end

defmodule SlackBot.MessageBrain.Nil do
  @moduledoc false

  @spec identifier :: nil
  def identifier, do: nil

  @spec decide(String.t) :: boolean
  def decide(_message), do: true

  @spec fetch(String.t) :: String.t
  def fetch(message), do: message

  @spec execute(String.t) :: tuple
  def execute(_message), do: {:skip}
end

defmodule SlackBot.MessageBrain.AddMessage do
  @moduledoc false

  import SlackBot.Gettext

  alias SlackBot.Schema.Phrase

  @spec identifier :: String.t
  def identifier, do: "add message"

  @spec decide(String.t) :: boolean
  def decide(message), do: message =~ identifier()

  @spec fetch(String.t) :: String.t
  def fetch(message) do
    Regex.scan(~r/#{identifier()} (.{1,})/, message)
    |> List.flatten
    |> List.last
  end

  @spec execute(String.t) :: tuple
  def execute(phrase) do
    changeset = %Phrase{}
                |> Phrase.changeset(%{phrase: fetch(phrase)})

    case SlackBot.Repo.insert(changeset) do
      {:ok, _} -> {:ok, gettext("The message was registered successfully :blush:")}
      {:error, %{errors: errors}} -> {:error, SlackBot.EctoHelper.pretty_errors(errors)}
    end
  end
end
