defmodule Populus.Servings.Sentiment do
  @moduledoc """
  Sentiment Analysis

  https://huggingface.co/finiteautomata/bertweet-base-sentiment-analysis
  """
  @behaviour Populus.Servings
  import Populus.Servings

  def child_spec() do
    {Nx.Serving, serving: serving(), name: name()}
  end

  def predict(text) do
    predict(name(), text)
  end

  defp name() do
    ServingSentiment
  end

  defp serving() do
    Bumblebee.Text.text_classification(
      load_model({:hf, "finiteautomata/bertweet-base-sentiment-analysis"}),
      load_tokenizer({:hf, "vinai/bertweet-base"})
    )
  end
end
