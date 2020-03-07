defmodule HomeMiku.Slack.Rtm do
  use Slack

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_event(%{type: "message", subtype: "message_changed"}, _, state), do: {:ok, state}
  def handle_event(%{type: "message", subtype: "message_deleted"}, _, state), do: {:ok, state}
  def handle_event(%{type: "message", subtype: "channel_join"}, _, state), do: {:ok, state}

  def handle_event(message = %{type: "message"}, slack, state) do
    if message_to_myself(message, slack) do
      send_message "I got a message!", message.channel, slack
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

  @spec message_to_myself(%{text: String.t}, Slack.State.t) :: boolean
  def message_to_myself(message, slack) do
    String.match?(message.text, ~r/<@#{slack.me.id}>/)
  end
end
