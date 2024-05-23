defmodule Populus.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :body, :text
      add :negative, :float
      add :neutral, :float
      add :positive, :float
      add :named_entities, {:array, :string}

      timestamps(type: :utc_datetime)
    end
  end
end
