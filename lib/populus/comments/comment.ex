defmodule Populus.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:body, :named_entities, :positive, :negative, :neutral],
    sortable: [:positive, :negative, :neutral],
  }


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field :positive, :float
    field :body, :string
    field :neutral, :float
    field :negative, :float
    field :named_entities, {:array, :string}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :negative, :neutral, :positive, :named_entities])
    |> validate_required([:body, :negative, :neutral, :positive, :named_entities])
  end
end
