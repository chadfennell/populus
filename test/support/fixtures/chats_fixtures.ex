defmodule Populus.ChatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Populus.Chats` context.
  """

  @doc """
  Generate a chat.
  """
  def chat_fixture(attrs \\ %{}) do
    {:ok, chat} =
      attrs
      |> Enum.into(%{
        named_entities: ["option1", "option2"],
        negative: 120.5,
        neutral: 120.5,
        positive: 120.5,
        question: "some question",
        response: "some response"
      })
      |> Populus.Chats.create_chat()

    chat
  end
end
