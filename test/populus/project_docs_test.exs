defmodule Populus.ProjectDocsTest do
  use Populus.DataCase

  alias Populus.ProjectDocs

  describe "project_docs" do
    alias Populus.ProjectDocs.ProjectDoc

    import Populus.ProjectDocsFixtures

    @invalid_attrs %{text: nil, title: nil, embedding: nil}

    test "list_project_docs/0 returns all project_docs" do
      project_doc = project_doc_fixture()
      assert ProjectDocs.list_project_docs() == [project_doc]
    end

    test "get_project_doc!/1 returns the project_doc with given id" do
      project_doc = project_doc_fixture()
      assert ProjectDocs.get_project_doc!(project_doc.id) == project_doc
    end

    test "create_project_doc/1 with valid data creates a project_doc" do
      valid_attrs = %{text: "some text", title: "some title", embedding: "some embedding"}

      assert {:ok, %ProjectDoc{} = project_doc} = ProjectDocs.create_project_doc(valid_attrs)
      assert project_doc.text == "some text"
      assert project_doc.title == "some title"
      assert project_doc.embedding == "some embedding"
    end

    test "create_project_doc/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProjectDocs.create_project_doc(@invalid_attrs)
    end

    test "update_project_doc/2 with valid data updates the project_doc" do
      project_doc = project_doc_fixture()
      update_attrs = %{text: "some updated text", title: "some updated title", embedding: "some updated embedding"}

      assert {:ok, %ProjectDoc{} = project_doc} = ProjectDocs.update_project_doc(project_doc, update_attrs)
      assert project_doc.text == "some updated text"
      assert project_doc.title == "some updated title"
      assert project_doc.embedding == "some updated embedding"
    end

    test "update_project_doc/2 with invalid data returns error changeset" do
      project_doc = project_doc_fixture()
      assert {:error, %Ecto.Changeset{}} = ProjectDocs.update_project_doc(project_doc, @invalid_attrs)
      assert project_doc == ProjectDocs.get_project_doc!(project_doc.id)
    end

    test "delete_project_doc/1 deletes the project_doc" do
      project_doc = project_doc_fixture()
      assert {:ok, %ProjectDoc{}} = ProjectDocs.delete_project_doc(project_doc)
      assert_raise Ecto.NoResultsError, fn -> ProjectDocs.get_project_doc!(project_doc.id) end
    end

    test "change_project_doc/1 returns a project_doc changeset" do
      project_doc = project_doc_fixture()
      assert %Ecto.Changeset{} = ProjectDocs.change_project_doc(project_doc)
    end
  end
end
