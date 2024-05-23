defmodule Populus.Services.Embeddings do
  @moduledoc """
  A client for interacting with the DeepInfra Mixtral AI API to get embeddings.
  """

  alias Populus.Services.DeepInfra

  @api_url "https://api.deepinfra.com/v1/inference/intfloat/e5-large-v2"

  def generate(text) do
    bearer_token = Application.fetch_env!(:populus, :deep_infra)[:api_key]

    case DeepInfra.send_request(text, bearer_token, @api_url) do
      {:ok, body, body_map} -> {:ok, extract_response(body)}
      {:error, reason} -> {:error, reason}
    end
  end

  defp extract_response(body) do
    response = Jason.decode!(body)
    [embeddings | _rest] = response["embeddings"]
    embeddings
  end
end
