defmodule PopulusWeb.Simulator do
  use PopulusWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, responses: [], result: false)}
  end

  def handle_event("post", %{"message" => message}, socket) do
    message_fn = fn ->
      {:ok, message} = Populus.Message.route(message)
      {:ok, %{result: message}}
    end

    IO.inspect(message_fn.())

    {:noreply, assign_async(socket, :result, message_fn)}
  end
end
