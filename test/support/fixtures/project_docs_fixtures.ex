defmodule Populus.ProjectDocsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Populus.ProjectDocs` context.
  """

  @doc """
  Generate a project_doc.
  """
  def project_doc_fixture(attrs \\ %{}) do
    {:ok, project_doc} =
      attrs
      |> Enum.into(%{
        embedding: "some embedding",
        text: "some text",
        title: "some title"
      })
      |> Populus.ProjectDocs.create_project_doc()

    project_doc
  end
end
