defmodule Populus.Questions do
  @moduledoc """
  The Questions context.
  """

  import Ecto.Query, warn: false
  alias Populus.Repo

  alias Populus.Questions.Question

  def record_question(question) do
    %{sentiment: sentiment_attrs} = Populus.Servings.Sentiment.predict(question)
    entities = Populus.Servings.NER.predict(question)
    {:ok, response} = answer(question)

    %{body: question, response: response}
    |> Map.merge(sentiment_attrs)
    |> Map.merge(entities)
    |> IO.inspect()
    |> create_question()
  end

  def question?(prompt) do
    %{q_or_s: %{question: q, statement: s}} = Populus.Servings.QorS.predict(prompt)

    # We need a second check to handle cases like:
    # "I need info on project xzy" Mixtral will code these as a
    # question. Our service tends to miss these.
    q > s || Populus.Services.QorS.predict(prompt) == {:ok, :question}
  end

  def answer(prompt) do
    prompt
    |> Populus.ProjectDocs.rag_suggestions()
    |> Enum.join("\n")
    |> Populus.Services.Rag.generate(prompt)
  end

  @doc """
  Returns the list of questions.

  ## Examples

      iex> list_questions()
      [%Question{}, ...]

  """
  def list_questions(params \\ %{}) do
    Flop.validate_and_run(Question, params, for: Question)
  end

  @doc """
  Gets a single question.

  Raises `Ecto.NoResultsError` if the Question does not exist.

  ## Examples

      iex> get_question!(123)
      %Question{}

      iex> get_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question!(id), do: Repo.get!(Question, id)

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a question.

  ## Examples

      iex> update_question(question, %{field: new_value})
      {:ok, %Question{}}

      iex> update_question(question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question changes.

  ## Examples

      iex> change_question(question)
      %Ecto.Changeset{data: %Question{}}

  """
  def change_question(%Question{} = question, attrs \\ %{}) do
    Question.changeset(question, attrs)
  end
end
