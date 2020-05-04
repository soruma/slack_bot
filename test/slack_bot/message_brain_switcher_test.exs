defmodule SlackBot.MessageBrain.SwitcherTest do
  use ExUnit.Case
  doctest SlackBot.MessageBrain.Switcher

  alias SlackBot.MessageBrain.Switcher

  describe "switch/1" do
    test "return AddMessage if the message contains 'add message'" do
      message = "add message"
      assert SlackBot.MessageBrain.AddMessage = Switcher.switch(message)
    end

    test "return Nil if not match any conditions" do
      message = "Hi"
      assert SlackBot.MessageBrain.Nil = Switcher.switch(message)
    end
  end
end

defmodule SlackBot.MessageBrain.NilTest do
  use ExUnit.Case
  doctest SlackBot.MessageBrain.Nil

  alias SlackBot.MessageBrain.Nil

  describe "identifier/0" do
    test "return nil" do
      assert match?(nil, Nil.identifier)
    end
  end

  describe "decide/1" do
    test "always decide" do
      assert true = Nil.decide("this is a message")
    end
  end

  describe "fetch/1" do
    test "return the message as is" do
      assert "this is a message" = Nil.fetch("this is a message")
    end
  end

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

  describe "identifier/0" do
    test "it is 'add message'" do
      assert "add message" = AddMessage.identifier
    end
  end

  describe "decide/1" do
    test "return true when 'add message' is include" do
      message = "Hi bot add message test message"
      assert true = AddMessage.decide(message)
    end

    test "return false without 'add message' is include" do
      message = "Hi bot"
      assert match?(false, AddMessage.decide(message))
    end
  end

  describe "fetch/1" do
    test "return extract string after identifier if the message contains identifier" do
      message = "Hi bot add message test message"
      assert "test message" = AddMessage.fetch(message)
    end

    test "return nil if the message does not include an identifier" do
      message = "Hi bot"
      assert match?(nil, AddMessage.fetch(message))
    end
  end

  describe "execute/1" do
    test "add a record to Phrase if valid param" do
      {:ok, send_message} = AddMessage.execute("Hi bot add message test message")
      assert "The message was registered successfully :blush:" = send_message

      query = Phrase
              |> where([p], p.phrase == "test message")
              |> select([p], count(p.id))
      assert [1] = Repo.all(query)
    end

    test "record not add if invalid param" do
      {:error, send_message} = AddMessage.execute("Hi bot")
      assert ["Phrase can't be blank"] = send_message

      query = Phrase |> select([p], count(p.id))
      assert [0] = Repo.all(query)
    end
  end
end
