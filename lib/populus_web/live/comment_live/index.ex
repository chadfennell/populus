defmodule PopulusWeb.CommentLive.Index do
  use PopulusWeb, :live_view
  alias Populus.Comments
  alias Populus.Comments.Comment
  import Populus.Components.Forms

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :comments, [])}
  end

  @impl true
  def handle_params(params, _, %{assigns: %{live_action: :index}} = socket) do
    case Comments.list_comments(params) do
      {:ok, {comments, meta}} ->
        {:noreply, assign(socket, %{comments: comments, meta: meta})}

      {:error, _meta} ->
        # This will reset invalid parameters. Alternatively, you can assign
        # only the meta and render the errors, or you can ignore the error
        # case entirely.
        {:noreply, push_navigate(socket, to: ~p"/questions")}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Comment")
    |> assign(:comment, Comments.get_comment!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Comment")
    |> assign(:comment, %Comment{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Comments")
    |> assign(:comment, nil)
  end

  @impl true
  def handle_info({PopulusWeb.CommentLive.FormComponent, {:saved, comment}}, socket) do
    {:noreply, stream_insert(socket, :comments, comment)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    comment = Comments.get_comment!(id)
    {:ok, _} = Comments.delete_comment(comment)

    {:noreply, stream_delete(socket, :comments, comment)}
  end

  def handle_event("update-filter", %{"reset" => _reset} = _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/comments")}
  end

  def handle_event("update-filter", params, socket) do
    IO.inspect(params)
    params = Map.delete(params, "_target")
    {:noreply, push_patch(socket, to: ~p"/comments?#{params}")}
  end
end
