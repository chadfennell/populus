defmodule Populus.QuestionsTest do
  use Populus.DataCase

  alias Populus.Questions

  describe "questions" do
    alias Populus.Questions.Question

    import Populus.QuestionsFixtures

    @invalid_attrs %{positive: nil, response: nil, body: nil, neutral: nil, negative: nil, named_entities: nil}

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Questions.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Questions.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      valid_attrs = %{positive: 120.5, response: "some response", body: "some body", neutral: 120.5, negative: 120.5, named_entities: ["option1", "option2"]}

      assert {:ok, %Question{} = question} = Questions.create_question(valid_attrs)
      assert question.positive == 120.5
      assert question.response == "some response"
      assert question.body == "some body"
      assert question.neutral == 120.5
      assert question.negative == 120.5
      assert question.named_entities == ["option1", "option2"]
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questions.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      update_attrs = %{positive: 456.7, response: "some updated response", body: "some updated body", neutral: 456.7, negative: 456.7, named_entities: ["option1"]}

      assert {:ok, %Question{} = question} = Questions.update_question(question, update_attrs)
      assert question.positive == 456.7
      assert question.response == "some updated response"
      assert question.body == "some updated body"
      assert question.neutral == 456.7
      assert question.negative == 456.7
      assert question.named_entities == ["option1"]
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Questions.update_question(question, @invalid_attrs)
      assert question == Questions.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Questions.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Questions.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Questions.change_question(question)
    end
  end
end
