defmodule Populus.Servings do
  @callback serving() :: Nx.Serving.t()
  @callback predict(String.t()) :: term
  @callback name() :: atom()

  def load_model(model) do
    {:ok, model_info} = Bumblebee.load_model(model)
    model_info
  end

  def load_tokenizer(tokenizer) do
    {:ok, tokenizer_info} = Bumblebee.load_tokenizer(tokenizer)
    tokenizer_info
  end

  def predict(name, text) do
    Nx.Serving.batched_run(name, text, &Nx.backend_transfer/1)
  end
end
