defmodule PopulusWeb.ProjectDocLive.Show do
  use PopulusWeb, :live_view

  alias Populus.ProjectDocs

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:project_doc, ProjectDocs.get_project_doc!(id))}
  end

  defp page_title(:show), do: "Show Project doc"
  defp page_title(:edit), do: "Edit Project doc"
end
