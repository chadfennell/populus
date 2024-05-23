defmodule Populus.Services.ChatCompletion do
  @moduledoc """
  A client for interacting with the DeepInfra Mixtral AI API for chat completions.
  """

  alias Populus.Services.DeepInfra
  alias Populus.Utils

  @api_url "https://api.deepinfra.com/v1/inference/mistralai/Mixtral-8x7B-Instruct-v0.1"

  def generate(context, prompt) do
    bearer_token = Application.fetch_env!(:populus, :deep_infra)[:api_token]
    text = system_instruction(context, prompt)

    case DeepInfra.send_request(text, bearer_token, @api_url) do
      {:ok, body, _body_map} -> {:ok, extract_response(body)}
      {:error, reason} -> {:error, reason}
    end
  end

  defp system_instruction(context, prompt) do
    sanitized_context = Utils.sanitize_context(context)

    """
    <<SYS>>
    We have provided context information below.
    -------------------------
    #{sanitized_context}
    -------------------------
    Given this information, please answer the question.
    Please respond in valid JSON in the following format:
    {"id": [ID], "body": "[TEXT]", "response": "[RESPONSE]"}
    <<SYS>>
    """
  end

  defp extract_response(body) do
    %{"results" => results} = Jason.decode!(body)

    Enum.map(results, fn res ->
      res["generated_text"]
      |> String.trim()
      |> Jason.decode!()
    end)
  end
end
