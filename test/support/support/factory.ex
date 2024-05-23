defmodule Populus.Factory do
  alias Populus.Repo
  alias Populus.ProjectDocs.ProjectDoc

  def build(:project_doc) do
    %ProjectDoc{}
  end

  def build(:project_doc, attrs) do
    text = Map.get(attrs, :text)

    rag_text =
      text
      |> String.split(" ")
      |> Enum.take(250)
      |> Enum.join(" ")

    {:ok, embeddings} = Populus.Services.Embeddings.generate(text)

    attrs =
      attrs
      |> Map.put(:rag_text, rag_text)
      |> Map.put(:embeddings, embeddings)

    build(:project_doc) |> struct!(attrs)
  end

  def build(factory_name, attrs) do
    factory_name |> build() |> struct!(attrs)
  end

  def insert!(factory_name, attrs \\ []) do
    factory_name |> build(attrs) |> Repo.insert!()
  end
end
