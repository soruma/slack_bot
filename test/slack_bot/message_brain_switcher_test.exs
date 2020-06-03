defmodule SlackBot.MessageBrain.SwitcherTest do
  use ExUnit.Case
  doctest SlackBot.MessageBrain.Switcher

  alias SlackBot.MessageBrain.Switcher

  describe "switch/1" do
    test "return AddMessage if the message contains 'add message'" do
      message = "add message"
      assert SlackBot.MessageBrain.AddMessage = Switcher.switch(message)
    end

    test "return DeleteMessage if the message contains 'delete message'" do
      message = "delete message"
      assert SlackBot.MessageBrain.DeleteMessage = Switcher.switch(message)
    end

    test "return MessageList if the message contains 'message list'" do
      message = "message list"
      assert SlackBot.MessageBrain.MessageList = Switcher.switch(message)
    end

    test "return Nil if not match any conditions" do
      message = "Hi"
      assert SlackBot.MessageBrain.Nil = Switcher.switch(message)
    end
  end
end

defmodule SlackBot.MessageBrainTest do
  use ExUnit.Case
  use SlackBot.MessageBrain, identifier: "add message"
  doctest SlackBot.MessageBrain

  describe "decide/1" do
    test "return true when 'add message' is include" do
      message = "Hi bot add message test message"
      assert true = decide(message)
    end

    test "return false without 'add message' is include" do
      message = "Hi bot"
      assert match?(false, decide(message))
    end
  end

  describe "fetch/1" do
    test "return extract string after identifier if the message contains identifier" do
      message = "Hi bot add message test message"
      assert "test message" = fetch(message)
    end

    test "return nil if the message does not include an identifier" do
      message = "Hi bot"
      assert match?(nil, fetch(message))
    end
  end
end

defmodule SlackBot.MessageBrain.NilTest do
  use ExUnit.Case
  doctest SlackBot.MessageBrain.Nil

  alias SlackBot.MessageBrain.Nil

  describe "execute/1" do
    test "return :skip" do
      assert {:skip} = Nil.execute("this is a message")
    end
  end
end

defmodule SlackBot.MessageBrain.AddMessageTest do
  use ExUnit.Case
  use SlackBot.RepoCase
  doctest SlackBot.MessageBrain.AddMessage

  alias SlackBot.MessageBrain.AddMessage
  alias SlackBot.Schema.Phrase

  describe "execute/1" do
    test "add a record to Phrase if valid param" do
      {:ok, send_message} = AddMessage.execute("Hi bot add message test message")
      assert "The message was registered successfully :blush:" = send_message

      assert 1 = length(Repo.all(Phrase |> where([p], p.phrase == "test message")))
    end

    test "record not add if invalid param" do
      {:error, send_message} = AddMessage.execute("Hi bot")
      assert ["Phrase can't be blank"] = send_message

      assert 0 = length(Repo.all(Phrase))
    end
  end
end

defmodule SlackBot.MessageBrain.DeleteMessageTest do
  use ExUnit.Case
  use SlackBot.RepoCase
  doctest SlackBot.MessageBrain.DeleteMessage

  alias SlackBot.MessageBrain.DeleteMessage
  alias SlackBot.Schema.Phrase

  describe "execute/1" do
    test "delete record Phrase if matches phrase" do
      SlackBot.Repo.insert(%Phrase{phrase: "target message"})

      {:ok, send_message} = DeleteMessage.execute("Hi bot delete message target message")
      assert "target message was deleted successfully :+1:" = send_message

      query =
        Phrase
        |> where([p], p.phrase == "target message")
        |> select([p], count(p.id))

      assert [0] = Repo.all(query)
    end

    test "return an error message if not found phrase" do
      {:error, send_message} = DeleteMessage.execute("Hi bot delete message target message")
      assert "target message is not found :sweat_smile:" = send_message
    end
  end
end

defmodule SlackBot.MessageBrain.MessageListTest do
  use ExUnit.Case
  use SlackBot.RepoCase
  doctest SlackBot.MessageBrain.MessageList

  alias SlackBot.MessageBrain.MessageList
  alias SlackBot.Schema.Phrase

  describe "execute/1" do
    test "return phrase list" do
      SlackBot.Repo.insert_all(Phrase, [%{phrase: "test message"}, %{phrase: "message"}])

      assert {:ok, ["test message", "message"]} = MessageList.execute("message list")
    end

    test "return error message if phrase is not registered" do
      assert {:ok, "not found phrase"} = MessageList.execute("message list")
    end
  end
end
