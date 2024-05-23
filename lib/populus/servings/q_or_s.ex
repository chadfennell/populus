defmodule Populus.Servings.QorS do
  @moduledoc """
  Question vs Statement Classification

  https://huggingface.co/shahrukhx01/question-vs-statement-classifier
  """
  @behaviour Populus.Servings
  import Populus.Servings

  def name() do
    ServingQorS
  end

  def serving() do
    Bumblebee.Text.text_classification(
      load_model({:hf, "shahrukhx01/question-vs-statement-classifier"}),
      load_tokenizer({:hf, "google-bert/bert-base-uncased"})
    )
  end

  def predict(text) do
    predict(name(), text) |> to_q_or_s()
  end

  defp to_q_or_s(result) do
    %{predictions: predictions} = result

    q_or_s =
      Enum.reduce(predictions, %{}, fn
        %{label: "LABEL_0", score: score}, acc ->
          Map.put(acc, :statement, score)

        %{label: "LABEL_1", score: score}, acc ->
          Map.put(acc, :question, score)
      end)

    %{q_or_s: q_or_s}
  end
end
