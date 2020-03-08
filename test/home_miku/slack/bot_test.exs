defmodule HomeMiku.Slack.BotTest do
  use ExUnit.Case
  doctest HomeMiku.Slack.Bot

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
      message = %{type: "message", subtype: "message_changed"}
      assert {:skip} = HomeMiku.Slack.Bot.react_to_message(message, state)
    end

    test "skip if subtype is 'message_deleted'", %{state: state} = _context do
      message = %{type: "message", subtype: "message_deleted"}
      assert {:skip} = HomeMiku.Slack.Bot.react_to_message(message, state)
    end

    test "skip if subtype is 'channel_join'", %{state: state} = _context do
      message = %{type: "message", subtype: "channel_join"}
      assert {:skip} = HomeMiku.Slack.Bot.react_to_message(message, state)
    end

    test "call interpret_attachment if message is attacthment" do
      # todo
    end

    test "call interpret_message if message is other tuple" do
      # todo
    end
  end

  describe "interpret_attachment/1" do
    test "attachement.title is 'Approached at home'" do
      attachments = [%{title: "Approached at home"}]
      assert {:send_message, _} = HomeMiku.Slack.Bot.interpret_attachment(attachments)
    end

    test "attachment.title is other text" do
      attachments = [%{title: "Other text"}]
      assert {:skip} = HomeMiku.Slack.Bot.interpret_attachment(attachments)
    end
  end

  describe "interpret_message/2" do
    test "respond to messages addressed to other", context do
      message = %{text: "Hi <@UOTHERUSERID> . How are you."}
      assert {:skip} = HomeMiku.Slack.Bot.interpret_message(message, context[:state])
    end

    test "respond to messages addressed to me", context do
      message = %{text: "Hi <@#{context[:user_id]}> . How are you."}
      assert {:send_message, _} = HomeMiku.Slack.Bot.interpret_message(message, context[:state])
    end
  end

  describe "message_to_myself/2" do
    test "it is a message not assigned to anyone", context do
      message = %{text: "Hi"}
      assert HomeMiku.Slack.Bot.message_to_myself(message, context[:state]) == false
    end

    test "it is a message assigned to other", context do
      message = %{text: "Hi <@UOTHERUSERID> . How are you."}
      assert HomeMiku.Slack.Bot.message_to_myself(message, context[:state]) == false
    end

    test "it is a message assigned to me", context do
      message = %{text: "Hi <@#{context[:user_id]}> . How are you."}
      assert HomeMiku.Slack.Bot.message_to_myself(message, context[:state]) == true
    end
  end
end
