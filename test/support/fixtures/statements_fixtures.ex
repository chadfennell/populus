defmodule Populus.StatementsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Populus.Statements` context.
  """

  @doc """
  Generate a statement.
  """
  def statement_fixture(attrs \\ %{}) do
    {:ok, statement} =
      attrs
      |> Enum.into(%{
        body: "some body",
        negative: 120.5,
        neutral: 120.5,
        positive: 120.5
      })
      |> Populus.Statements.create_statement()

    statement
  end
end
