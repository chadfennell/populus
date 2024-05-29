defmodule Populus.Servings.Sentiment do
  @moduledoc """
  Sentiment Analysis

  https://huggingface.co/finiteautomata/bertweet-base-sentiment-analysis
  """
  @behaviour Populus.Servings
  require Logger
  import Populus.Servings

  def child_spec() do
    {Nx.Serving, serving: serving(), name: name()}
  end

  def predict(text) do
    %{predictions: predictions} = predict(name(), text)

    q_or_s =
      Enum.reduce(predictions, %{}, fn
        %{label: "NEG", score: score}, acc ->
          Map.put(acc, :negative, score)

        %{label: "POS", score: score}, acc ->
          Map.put(acc, :positive, score)

        %{label: "NEU", score: score}, acc ->
          Map.put(acc, :neutral, score)
      end)

    Logger.info("[ML:Sentiment] input [#{text}] output [#{inspect(q_or_s)}]")

    %{sentiment: q_or_s}
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
