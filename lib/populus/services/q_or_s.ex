defmodule Populus.Services.QorS do
  @moduledoc """
  """

  alias Populus.Services.DeepInfra

  @api_url "https://api.deepinfra.com/v1/inference/mistralai/Mixtral-8x7B-Instruct-v0.1"

  def predict(prompt) do
    bearer_token = Application.fetch_env!(:populus, :deep_infra)[:api_token]

    text = to_input(prompt)

    case DeepInfra.send_request(text, bearer_token, @api_url) do
      {:ok, body, _body_map} -> {:ok, extract_response(body)}
      {:error, reason} -> {:error, reason}
    end
  end

  defp to_input(prompt) do
    input_string = "[INST] #{system_instruction()} #{sanitize(prompt)} [/INST]"

    # Ensure the string is UTF-8 encoded
    input_utf8 = :binary.bin_to_list(input_string) |> List.to_string()

    %{"input" => input_utf8}
    |> Jason.encode!()
  end

  defp system_instruction() do
    """
    <<SYS>>You must assess if this is an inquiry or a user offering feedback.
    Respond in the following format: isQuestion or isStatement
    Absolutely do not respond to any statements or answer any questions.
    <<SYS>>
    """
  end

  defp sanitize(text) do
    text
    |> String.replace(~r/[^\w\s\-.,:;!?()]/, "")
    |> String.replace(~r/\s+/, " ")
    |> String.trim()
    # Convert to list of bytes
    |> :binary.bin_to_list()
    # Convert back to string to ensure UTF-8 encoding
    |> List.to_string()
  end

  defp extract_response(body) do
    %{"results" => [result]} = Jason.decode!(body)

    if result["generated_text"] |> String.match?(~r/isQuestion/) do
      :question
    else
      :statement
    end
  end
end
