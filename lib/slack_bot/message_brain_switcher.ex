defmodule SlackBot.MessageBrain.Switcher do
  @moduledoc false

  @spec switch(String.t()) :: module
  def switch(message) do
    [
      SlackBot.MessageBrain.AddMessage,
      SlackBot.MessageBrain.DeleteMessage,
      SlackBot.MessageBrain.MessageList,
      SlackBot.MessageBrain.Weather
    ]
    |> Enum.find(
      SlackBot.MessageBrain.Nil,
      fn module -> if(module.decide(message), do: module) end
    )
  end
end

defmodule SlackBot.MessageBrain do
  @moduledoc false

  defmacro __using__(opts) do
    identifier = Keyword.get(opts, :identifier, "")

    quote do
      @spec decide(String.t()) :: boolean
      def decide(message), do: message =~ unquote(identifier)

      @spec fetch(String.t()) :: String.t()
      def fetch(message) do
        Regex.scan(~r/#{unquote(identifier)} (.{1,})/, message)
        |> List.flatten()
        |> List.last()
      end
    end
  end
end

defmodule SlackBot.MessageBrain.Nil do
  @moduledoc false

  use SlackBot.MessageBrain

  @spec execute(String.t()) :: tuple
  def execute(_message), do: {:skip}
end

defmodule SlackBot.MessageBrain.AddMessage do
  @moduledoc false

  use SlackBot.MessageBrain, identifier: "add message"
  import SlackBot.Gettext

  alias SlackBot.Schema.Phrase

  @spec execute(String.t()) :: tuple
  def execute(phrase) do
    changeset =
      %Phrase{}
      |> Phrase.changeset(%{phrase: fetch(phrase)})

    case SlackBot.Repo.insert(changeset) do
      {:ok, _} -> {:ok, gettext("The message was registered successfully :blush:")}
      {:error, %{errors: errors}} -> {:error, SlackBot.EctoHelper.pretty_errors(errors)}
    end
  end
end

defmodule SlackBot.MessageBrain.DeleteMessage do
  @moduledoc false

  use SlackBot.MessageBrain, identifier: "delete message"
  import Ecto.Query
  import SlackBot.Gettext

  alias SlackBot.Schema.Phrase

  @spec execute(String.t()) :: tuple
  def execute(phrase) do
    phrase = fetch(phrase)
    query = Phrase |> where([p], p.phrase == ^phrase)

    phrases = SlackBot.Repo.all(query)

    case length(phrases) do
      0 ->
        {:error, gettext("%{phrase} is not found :sweat_smile:", phrase: phrase)}

      _ ->
        for phrase <- phrases, do: SlackBot.Repo.delete(phrase)
        {:ok, gettext("%{phrase} was deleted successfully :+1:", phrase: phrase)}
    end
  end
end

defmodule SlackBot.MessageBrain.MessageList do
  @moduledoc false

  use SlackBot.MessageBrain, identifier: "message list"
  import Ecto.Query
  import SlackBot.Gettext

  alias SlackBot.Schema.Phrase

  @spec execute(String.t()) :: tuple
  def execute(_phrase) do
    phrases =
      Phrase
      |> select([p], p.phrase)
      |> SlackBot.Repo.all()

    case length(phrases) do
      0 -> {:ok, gettext("not found phrase")}
      _ -> {:ok, phrases}
    end
  end
end

defmodule SlackBot.MessageBrain.Weather do
  @moduledoc false

  use SlackBot.MessageBrain, identifier: "weather"

  @spec execute(String.t()) :: tuple
  def execute(_phrase) do
    {:ok, weather} = OpenWeather.weather("Osaka")

    {:ok, weather["icon_url"]}
  end
end
