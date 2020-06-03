defmodule SlackBot.Slack.Bot do
  @moduledoc false

  import SlackBot.Gettext

  alias SlackBot.MessageBrain.Switcher

  @spec react_to_message(tuple, Slack.State.t()) :: tuple
  def react_to_message(%{subtype: "message_changed"}, _), do: {:skip}
  def react_to_message(%{subtype: "message_deleted"}, _), do: {:skip}
  def react_to_message(%{subtype: "channel_join"}, _), do: {:skip}

  def react_to_message(%{attachments: attachments}, _), do: interpret_attachment(attachments)
  def react_to_message(message, slack), do: interpret_message(message, slack.me.id)

  @spec interpret_attachment(list(tuple)) :: tuple
  def interpret_attachment([]), do: {:skip}

  def interpret_attachment([attachment | attachments]) do
    interpret_attachment(attachments)

    if attachment.title == "Approached at home" do
      {:send_message, gettext("Welcome back, master :heart:")}
    else
      {:skip}
    end
  end

  @spec interpret_message(tuple, String.t()) :: tuple
  def interpret_message(message, bot_id) do
    if message_to_myself(message, bot_id) do
      case Switcher.switch(message.text).execute(message.text) do
        {:ok, messages} ->
          if is_list(messages) do
            {:send_message, messages |> Enum.join("\n")}
          else
            {:send_message, messages}
          end

        {:error, error_messages} ->
          {:send_message, error_messages |> Enum.join("\n")}

        {:skip} ->
          {:skip}
      end
    else
      {:skip}
    end
  end

  @spec message_to_myself(%{text: String.t()}, String.t()) :: boolean
  def message_to_myself(message, bot_id) do
    String.match?(message.text, ~r/<@#{bot_id}>/)
  end
end
