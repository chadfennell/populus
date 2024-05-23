defmodule Populus.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:body, :response, :positive, :negative, :neutral],
    sortable: [:positive, :negative, :neutral]
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "questions" do
    field :response, :string
    field :body, :string
    field :positive, :float
    field :negative, :float
    field :neutral, :float
    field :named_entities, {:array, :string}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:body, :response, :negative, :neutral, :positive, :named_entities])
    |> validate_required([:body, :response, :negative, :neutral, :positive, :named_entities])
  end
end
