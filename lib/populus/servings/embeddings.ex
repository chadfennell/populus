defmodule Populus.Serving.Embeddings do
  @moduledoc """
  Embeddings

  https://huggingface.co/intfloat/e5-large-v2
  """
  @behaviour Populus.Servings
  import Populus.Servings

  def name() do
    ServingEmbedding
  end

  def child_spec() do
    {Nx.Serving, serving: serving(), name: name()}
  end

  def serving() do
    Bumblebee.Text.text_embedding(
      load_model({:hf, "intfloat/e5-large-v2"}),
      load_tokenizer({:hf, "intfloat/e5-large-v2"}),
      compile: [batch_size: 64, sequence_length: 1024],
      defn_options: [compiler: EXLA],
      output_attribute: :hidden_state,
      output_pool: :mean_pooling
    )
  end

  def predict(text) do
    predict(name(), text)
  end
end
