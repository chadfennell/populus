defmodule PopulusWeb.CommentLive.FormComponent do
  use PopulusWeb, :live_component

  alias Populus.Comments

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage comment records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="comment-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:body]} type="text" label="Body" />
        <.input field={@form[:negative]} type="number" label="Negative" step="any" />
        <.input field={@form[:neutral]} type="number" label="Neutral" step="any" />
        <.input field={@form[:positive]} type="number" label="Positive" step="any" />
        <.input
          field={@form[:named_entities]}
          type="select"
          multiple
          label="Named entities"
          options={[{"Option 1", "option1"}, {"Option 2", "option2"}]}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Comment</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{comment: comment} = assigns, socket) do
    changeset = Comments.change_comment(comment)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"comment" => comment_params}, socket) do
    changeset =
      socket.assigns.comment
      |> Comments.change_comment(comment_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"comment" => comment_params}, socket) do
    save_comment(socket, socket.assigns.action, comment_params)
  end

  defp save_comment(socket, :edit, comment_params) do
    case Comments.update_comment(socket.assigns.comment, comment_params) do
      {:ok, comment} ->
        notify_parent({:saved, comment})

        {:noreply,
         socket
         |> put_flash(:info, "Comment updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_comment(socket, :new, comment_params) do
    case Comments.create_comment(comment_params) do
      {:ok, comment} ->
        notify_parent({:saved, comment})

        {:noreply,
         socket
         |> put_flash(:info, "Comment created successfully")
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
