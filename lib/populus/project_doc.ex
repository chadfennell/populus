defmodule Populus.ProjectDocs.ProjectDoc do
  use Populus.Schema
  import Ecto.Changeset

  schema "project_docs" do
    field :title, :string
    field :text, :string
    field :embeddings, Pgvector.Ecto.Vector

    timestamps()
  end

  def validate_changeset(project_doc, attrs) do
    project_doc
    |> cast(attrs, [:title, :text])
    |> validate_required([ :title, :text])
  end


  def changeset(project_doc, attrs) do
    project_doc
    |> cast(attrs, [:embeddings, :title, :text])
    |> validate_required([:embeddings, :title, :text])
  end
end
