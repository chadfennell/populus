defmodule PopulusWeb.ProjectDocLive.Index do
  use PopulusWeb, :live_view

  alias Populus.ProjectDocs
  alias Populus.ProjectDocs.ProjectDoc

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :project_docs, ProjectDocs.list_project_docs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Project doc")
    |> assign(:project_doc, ProjectDocs.get_project_doc!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Project doc")
    |> assign(:project_doc, %ProjectDoc{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Project docs")
    |> assign(:project_doc, nil)
  end

  @impl true
  def handle_info({PopulusWeb.ProjectDocLive.FormComponent, {:saved, project_doc}}, socket) do
    {:noreply, stream_insert(socket, :project_docs, project_doc)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    project_doc = ProjectDocs.get_project_doc!(id)
    {:ok, _} = ProjectDocs.delete_project_doc(project_doc)

    {:noreply, stream_delete(socket, :project_docs, project_doc)}
  end
end
