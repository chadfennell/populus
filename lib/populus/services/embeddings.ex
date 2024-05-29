defmodule Populus.Services.Embeddings do
  @moduledoc """
  A client for interacting with the DeepInfra Mixtral AI API to get embeddings.
  """

  alias Populus.Services.DeepInfra

  @api_url "https://api.deepinfra.com/v1/inference/BAAI/bge-large-en-v1.5"

  def generate(text) do
    bearer_token = Application.fetch_env!(:populus, :deep_infra)[:api_key]

    prompt = to_inputs(text)

    case DeepInfra.send_request(prompt, bearer_token, @api_url) do
      {:ok, response, _query} -> {:ok, extract_response(response)}
      {:error, reason} -> {:error, reason}
    end
  end

  defp to_inputs(text) do
    %{"inputs" => [text]}
    |> Jason.encode!()
  end

  defp extract_response(response) do
    response = Jason.decode!(response)
    [embeddings | _rest] = response["embeddings"]
    embeddings
  end
end
