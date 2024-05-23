defmodule PopulusWeb.QuestionLive.Index do
  use PopulusWeb, :live_view
  import Populus.Components.Forms
  alias Populus.Questions
  alias Populus.Questions.Question

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :questions, [])}
  end

  @impl true
  def handle_params(params, _, %{assigns: %{live_action: :index}} = socket) do
    case Questions.list_questions(params) do
      {:ok, {questions, meta}} ->
        {:noreply, assign(socket, %{questions: questions, meta: meta})}

      {:error, _meta} ->
        # This will reset invalid parameters. Alternatively, you can assign
        # only the meta and render the errors, or you can ignore the error
        # case entirely.
        {:noreply, push_navigate(socket, to: ~p"/questions")}
    end
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Question")
    |> assign(:question, Questions.get_question!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Question")
    |> assign(:question, %Question{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Questions")
    |> assign(:question, nil)
  end

  @impl true
  def handle_info({PopulusWeb.QuestionLive.FormComponent, {:saved, question}}, socket) do
    {:noreply, stream_insert(socket, :questions, question)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    question = Questions.get_question!(id)
    {:ok, _} = Questions.delete_question(question)

    {:noreply, stream_delete(socket, :questions, question)}
  end

  def handle_event("update-filter", %{"reset" => _reset} = _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/questions")}
  end

  def handle_event("update-filter", params, socket) do
    params = Map.delete(params, "_target")
    {:noreply, push_patch(socket, to: ~p"/questions?#{params}")}
  end
end
