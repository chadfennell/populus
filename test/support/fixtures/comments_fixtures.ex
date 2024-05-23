defmodule Populus.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Populus.Comments` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        body: "some body",
        named_entities: ["option1", "option2"],
        negative: 120.5,
        neutral: 120.5,
        positive: 120.5
      })
      |> Populus.Comments.create_comment()

    comment
  end
end
