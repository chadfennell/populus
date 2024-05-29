defmodule Populus.Servings.NER do
  @moduledoc """
  Named Entity Recognition

  https://huggingface.co/dslim/bert-base-NER
  """
  @behaviour Populus.Servings
  import Populus.Servings

  def name() do
    ServingNER
  end

  def child_spec() do
    {Nx.Serving, serving: serving(), name: name()}
  end

  def serving() do
    Bumblebee.Text.token_classification(
      load_model({:hf, "dslim/bert-base-NER"}),
      load_tokenizer({:hf, "google-bert/bert-base-cased"}),
      aggregation: :same
    )
  end

  def predict(text) do
    %{entities: entities} = predict(name(), text)
    %{named_entities: Enum.map(entities, & &1.phrase)}
  end
end
