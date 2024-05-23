defmodule Populus.QuestionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Populus.Questions` context.
  """

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    {:ok, question} =
      attrs
      |> Enum.into(%{
        body: "some body",
        named_entities: ["option1", "option2"],
        negative: 120.5,
        neutral: 120.5,
        positive: 120.5,
        response: "some response"
      })
      |> Populus.Questions.create_question()

    question
  end
end
