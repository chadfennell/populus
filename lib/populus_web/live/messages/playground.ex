defmodule PopulusWeb.Messages.Playground do
  use PopulusWeb, :live_view
  import Populus.Components.Playground
  alias __MODULE__
  alias Populus.Classifier

  defstruct [:title, :type, :classify, message: "", result: "{}"]

  def mount(_params, _session, socket) do
    new_socket =
      socket
      |> assign(classifiers: classifiers())

    {:ok, new_socket}
  end

  def handle_event("classify", %{"message" => ""} = _params, socket) do
    {:noreply, socket}
  end

  def handle_event("classify", %{"message" => message, "type" => type}, socket) do
    classifiers =
      classifiers()
      |> Enum.map(fn
        %{type: ^type, classify: classify} = classifier ->
          {:ok, pretty_result} =
            message
            |> classify.()
            |> Jason.encode(pretty: true)

          classifier
          |> Map.put(:result, pretty_result)
          |> Map.put(:message, message)

        classifier ->
          classifier
      end)

    {:noreply, assign(socket, :classifiers, classifiers)}
  end

  defp classifiers() do
    [
      %Playground{
        title: "Named Entity Recognition",
        type: "nlp",
        classify: &Classifier.ner(&1)
      },
      %Playground{
        title: "Sentiment Analysis",
        type: "sentiment",
        classify: &Classifier.sentiment(&1)
      },
      %Playground{
        title: "Question or Statement",
        type: "question_or_statement",
        classify: &Classifier.question?(&1)
      }
    ]
  end
end
