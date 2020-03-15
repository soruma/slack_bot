defmodule SlackBot.Slack.BotTest do
  use ExUnit.Case
  doctest SlackBot.Slack.Bot

  setup do
    user_id = "UMYUSERID"

    {
      :ok,
      user_id: user_id,
      state: %Slack.State{me: %{id: user_id}},
    }
  end

  describe "react_to_message/2" do
    test "skip if subtype is 'message_changed'", %{state: state} = _context do
      message = %{subtype: "message_changed"}
      assert {:skip} = SlackBot.Slack.Bot.react_to_message(message, state)
    end

    test "skip if subtype is 'message_deleted'", %{state: state} = _context do
      message = %{subtype: "message_deleted"}
      assert {:skip} = SlackBot.Slack.Bot.react_to_message(message, state)
    end

    test "skip if subtype is 'channel_join'", %{state: state} = _context do
      message = %{subtype: "channel_join"}
      assert {:skip} = SlackBot.Slack.Bot.react_to_message(message, state)
    end

    test "return send_message if message is attacthment", context do
      attachments = %{attachments: [%{title: "Approached at home"}]}

      assert {:send_message, "Welcome back, master :heart:"} =
        SlackBot.Slack.Bot.react_to_message(attachments, context[:state])
    end

    test "return send_message if message is other tuple", context do
      message = %{text: "Hi <@#{context[:user_id]}> ."}

      assert {:send_message, "I got a message!"} =
        SlackBot.Slack.Bot.react_to_message(message, context[:state])
    end
  end

  describe "interpret_attachment/1" do
    test "attachement.title is 'Approached at home'" do
      attachments = [%{title: "Approached at home"}]
      assert {:send_message, _} = SlackBot.Slack.Bot.interpret_attachment(attachments)
    end

    test "attachment.title is other text" do
      attachments = [%{title: "Other text"}]
      assert {:skip} = SlackBot.Slack.Bot.interpret_attachment(attachments)
    end
  end

  describe "interpret_message/2" do
    test "respond to messages addressed to other", %{user_id: user_id} = _context do
      message = %{text: "Hi <@UOTHERUSERID> . How are you."}
      assert {:skip} = SlackBot.Slack.Bot.interpret_message(message, user_id)
    end

    test "respond to messages addressed to me", %{user_id: user_id} = _context do
      message = %{text: "Hi <@#{user_id}> . How are you."}
      assert {:send_message, _} = SlackBot.Slack.Bot.interpret_message(message, user_id)
    end
  end

  describe "message_to_myself/2" do
    test "it is a message not assigned to anyone", %{user_id: user_id} = _context do
      message = %{text: "Hi"}
      assert SlackBot.Slack.Bot.message_to_myself(message, user_id) == false
    end

    test "it is a message assigned to other", %{user_id: user_id} = _context do
      message = %{text: "Hi <@UOTHERUSERID> . How are you."}
      assert SlackBot.Slack.Bot.message_to_myself(message, user_id) == false
    end

    test "it is a message assigned to me", %{user_id: user_id} = _context do
      message = %{text: "Hi <@#{user_id}> . How are you."}
      assert SlackBot.Slack.Bot.message_to_myself(message, user_id) == true
    end
  end
end
