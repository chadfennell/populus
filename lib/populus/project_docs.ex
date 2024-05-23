defmodule Populus.ProjectDocs do
  @moduledoc """
  The ProjectDocs context.
  """

  import Ecto.Query, warn: false
  alias Populus.Repo

  alias Populus.ProjectDocs.ProjectDoc

  @doc """
  Returns the list of project_docs.

  ## Examples

      iex> list_project_docs()
      [%ProjectDoc{}, ...]

  """
  def list_project_docs do
    Repo.all(ProjectDoc)
  end

  @doc """
  Gets a single project_doc.

  Raises `Ecto.NoResultsError` if the Project doc does not exist.

  ## Examples

      iex> get_project_doc!(123)
      %ProjectDoc{}

      iex> get_project_doc!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project_doc!(id), do: Repo.get!(ProjectDoc, id)

  @doc """
  Creates a project_doc.

  ## Examples

      iex> create_project_doc(%{field: value})
      {:ok, %ProjectDoc{}}

      iex> create_project_doc(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project_doc(attrs \\ %{}) do
    %ProjectDoc{}
    |> ProjectDoc.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project_doc.

  ## Examples

      iex> update_project_doc(project_doc, %{field: new_value})
      {:ok, %ProjectDoc{}}

      iex> update_project_doc(project_doc, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project_doc(%ProjectDoc{} = project_doc, attrs) do
    project_doc
    |> ProjectDoc.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project_doc.

  ## Examples

      iex> delete_project_doc(project_doc)
      {:ok, %ProjectDoc{}}

      iex> delete_project_doc(project_doc)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project_doc(%ProjectDoc{} = project_doc) do
    Repo.delete(project_doc)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project_doc changes.

  ## Examples

      iex> change_project_doc(project_doc)
      %Ecto.Changeset{data: %ProjectDoc{}}

  """
  def change_project_doc(%ProjectDoc{} = project_doc, attrs \\ %{}) do
    ProjectDoc.changeset(project_doc, attrs)
  end

  def validate_project_doc(%ProjectDoc{} = project_doc, attrs \\ %{}) do
    ProjectDoc.validate_changeset(project_doc, attrs)
  end
end
