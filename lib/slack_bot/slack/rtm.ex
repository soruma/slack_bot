defmodule SlackBot.Slack.Rtm do
  @moduledoc false

  use Slack

  alias SlackBot.Slack.Bot

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    case Bot.react_to_message(message, slack) do
      {:send_message, result} -> send_message(result, message.channel, slack)
      _ -> :skip
    end

    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts "Sending your message, captain!"

    send_message text, channel, slack

    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}
end
