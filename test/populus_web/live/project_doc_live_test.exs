defmodule PopulusWeb.ProjectDocLiveTest do
  use PopulusWeb.ConnCase

  import Phoenix.LiveViewTest
  import Populus.ProjectDocsFixtures

  @create_attrs %{text: "some text", title: "some title", embedding: "some embedding"}
  @update_attrs %{text: "some updated text", title: "some updated title", embedding: "some updated embedding"}
  @invalid_attrs %{text: nil, title: nil, embedding: nil}

  defp create_project_doc(_) do
    project_doc = project_doc_fixture()
    %{project_doc: project_doc}
  end

  describe "Index" do
    setup [:create_project_doc]

    test "lists all project_docs", %{conn: conn, project_doc: project_doc} do
      {:ok, _index_live, html} = live(conn, ~p"/project_docs")

      assert html =~ "Listing Project docs"
      assert html =~ project_doc.text
    end

    test "saves new project_doc", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/project_docs")

      assert index_live |> element("a", "New Project doc") |> render_click() =~
               "New Project doc"

      assert_patch(index_live, ~p"/project_docs/new")

      assert index_live
             |> form("#project_doc-form", project_doc: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#project_doc-form", project_doc: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/project_docs")

      html = render(index_live)
      assert html =~ "Project doc created successfully"
      assert html =~ "some text"
    end

    test "updates project_doc in listing", %{conn: conn, project_doc: project_doc} do
      {:ok, index_live, _html} = live(conn, ~p"/project_docs")

      assert index_live |> element("#project_docs-#{project_doc.id} a", "Edit") |> render_click() =~
               "Edit Project doc"

      assert_patch(index_live, ~p"/project_docs/#{project_doc}/edit")

      assert index_live
             |> form("#project_doc-form", project_doc: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#project_doc-form", project_doc: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/project_docs")

      html = render(index_live)
      assert html =~ "Project doc updated successfully"
      assert html =~ "some updated text"
    end

    test "deletes project_doc in listing", %{conn: conn, project_doc: project_doc} do
      {:ok, index_live, _html} = live(conn, ~p"/project_docs")

      assert index_live |> element("#project_docs-#{project_doc.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#project_docs-#{project_doc.id}")
    end
  end

  describe "Show" do
    setup [:create_project_doc]

    test "displays project_doc", %{conn: conn, project_doc: project_doc} do
      {:ok, _show_live, html} = live(conn, ~p"/project_docs/#{project_doc}")

      assert html =~ "Show Project doc"
      assert html =~ project_doc.text
    end

    test "updates project_doc within modal", %{conn: conn, project_doc: project_doc} do
      {:ok, show_live, _html} = live(conn, ~p"/project_docs/#{project_doc}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Project doc"

      assert_patch(show_live, ~p"/project_docs/#{project_doc}/show/edit")

      assert show_live
             |> form("#project_doc-form", project_doc: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#project_doc-form", project_doc: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/project_docs/#{project_doc}")

      html = render(show_live)
      assert html =~ "Project doc updated successfully"
      assert html =~ "some updated text"
    end
  end
end
