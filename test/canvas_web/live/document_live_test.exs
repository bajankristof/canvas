defmodule CanvasWeb.DocumentLiveTest do
  use CanvasWeb.ConnCase

  import Phoenix.LiveViewTest
  import Canvas.GraphicsFixtures

  defp create_document(_) do
    document = document_fixture()
    %{document: document}
  end

  describe "index" do
    setup [:create_document]

    test "lists all documents", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.document_index_path(conn, :index))

      assert html =~ "Documents"
    end
  end

  describe "show" do
    setup [:create_document]

    test "displays document", %{conn: conn, document: document} do
      {:ok, _show_live, html} = live(conn, Routes.document_show_path(conn, :show, document))

      assert html =~ "Document #{document.id}"
    end
  end
end
