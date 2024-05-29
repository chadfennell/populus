defmodule Populus.Services.Rag do
  @moduledoc """
  A client for interacting with the DeepInfra Mixtral AI API for chat completions.
  """

  alias Populus.Services.DeepInfra

  @api_url "https://api.deepinfra.com/v1/inference/mistralai/Mixtral-8x7B-Instruct-v0.1"

  def generate(context, prompt) do
    bearer_token = Application.fetch_env!(:populus, :deep_infra)[:api_token]

    system_instruction = system_instruction(context)
    text = to_input(system_instruction, prompt)

    case DeepInfra.send_request(text, bearer_token, @api_url) do
      {:ok, body, _body_map} -> {:ok, extract_response(body)}
      {:error, reason} -> {:error, reason}
    end
  end

  defp to_input(context, prompt) do
    input_string = "[INST] #{sanitize(context)} #{sanitize(prompt)} [/INST]"

    # Ensure the string is UTF-8 encoded
    input_utf8 = :binary.bin_to_list(input_string) |> List.to_string()

    %{"input" => input_utf8}
    |> Jason.encode!()
  end

  defp system_instruction(context) do
    sanitized_context = sanitize(context)

    """
    <<SYS>>
    We have provided context information below.
    -------------------------
    #{sanitized_context}
    -------------------------
    Given this information, please answer the question.
    DO NOT OFFER SAFETY ADVICE
    <<SYS>>
    """
  end

  defp sanitize(context) do
    context
    |> String.replace(~r/[^\w\s\-.,:;!?()]/, "")
    |> String.replace(~r/\s+/, " ")
    |> String.trim()
    |> :binary.bin_to_list()  # Convert to list of bytes
    |> List.to_string()       # Convert back to string to ensure UTF-8 encoding
  end

  defp extract_response(body) do
    %{"results" => [result]} = Jason.decode!(body)

    result["generated_text"] |> String.trim()
  end
end
