defmodule Populus.Repo.Migrations.CreateProjectDocsTable do
  use Ecto.Migration

  def change do
    create table(:project_docs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :embeddings, :vector, size: 1024
      add :title, :string
      add :text, :text

      timestamps()
    end
  end
end