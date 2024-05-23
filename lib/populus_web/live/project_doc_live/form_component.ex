defmodule PopulusWeb.ProjectDocLive.FormComponent do
  use PopulusWeb, :live_component

  alias Populus.ProjectDocs

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage project_doc records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="project_doc-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:text]} type="textarea" label="Text" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Project doc</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{project_doc: project_doc} = assigns, socket) do
    changeset = ProjectDocs.change_project_doc(project_doc)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"project_doc" => project_doc_params}, socket) do
    changeset =
      socket.assigns.project_doc
      |> ProjectDocs.validate_project_doc(project_doc_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"project_doc" => project_doc_params}, socket) do
    save_project_doc(socket, socket.assigns.action, project_doc_params)
  end

  defp save_project_doc(socket, :edit, project_doc_params) do
    {:ok, embeddings} = Populus.Services.Embeddings.generate(project_doc_params["text"])

    project_doc_params = Map.put(project_doc_params, "embeddings", embeddings)

    case ProjectDocs.update_project_doc(socket.assigns.project_doc, project_doc_params) do
      {:ok, project_doc} ->
        notify_parent({:saved, project_doc})

        {:noreply,
         socket
         |> put_flash(:info, "Project doc updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_project_doc(socket, :new, project_doc_params) do
    {:ok, embeddings} = Populus.Services.Embeddings.generate(project_doc_params["text"])

    project_doc_params = Map.put(project_doc_params, "embeddings", embeddings)
    case ProjectDocs.create_project_doc(project_doc_params) do
      {:ok, project_doc} ->
        notify_parent({:saved, project_doc})

        {:noreply,
         socket
         |> put_flash(:info, "Project doc created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
