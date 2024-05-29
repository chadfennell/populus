defmodule Populus.Services.DeepInfra do
  @moduledoc """
  A helper module for request to DeepInfra
  """

  require Logger
  alias Finch.Response

  @content_type "application/json"

  @doc """
  Send a request to the Mistral AI API.
  """
  def send_request(text, bearer_token, api_url) do
    headers = [
      {"Content-Type", @content_type},
      {"Authorization", "Bearer #{bearer_token}"}
    ]

    options = [receive_timeout: 20_000]

    case Finch.build(:post, api_url, headers, text)
         |> Finch.request(Populus.Finch, options) do
      {:ok, %Response{status: 200, body: body}} ->
        {:ok, body, text}

      {:ok, %Response{status: status, body: body}} ->
        Logger.error("Request failed with status #{status}: #{body}")
        {:error, "Request failed with status #{status}"}

      {:error, reason} ->
        Logger.error("Request failed: #{inspect(reason)}")
        {:error, "Request failed: #{inspect(reason)}"}
    end
  end
end
