defmodule Populus.Message do
  @moduledoc """
  Encapsulates logic around routing incoming text messages, emails, etc in
  order to get users to the right kind of interaction: question answering,
  confirmation of feedback, etc.
  """
  require Logger
  alias Populus.Questions

  def route(message) do
    if Questions.question?(message) do
      Populus.Questions.record_question(message)
    else
      Populus.Comments.record_comment(message)
    end
  end
end
