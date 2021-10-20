defmodule CanvasWeb.GraphicsControllerTest do
  use CanvasWeb.ConnCase
  alias Canvas.Graphics
  alias Canvas.Graphics.Document

  @document_stub %{width: 24, height: 8}
  @draw_rect_command %{x: 1, y: 1, width: 5, height: 3, outline: "@", fill: "."}
  @flood_fill_command %{x: 0, y: 0, fill: "x"}

  setup %{conn: conn} do
    {:ok, document} = Graphics.create_document(@document_stub)
    {:ok, conn: put_req_header(conn, "accept", "application/json"), document: document}
  end

  describe "show" do
    test "renders empty document correctly", %{conn: conn, document: document} do
      conn = get(conn, Routes.graphics_path(conn, :show, document.id))
      assert conn.status === 200
      assert conn.resp_body === ""
    end

    test "renders document correctly", %{conn: conn, document: document} do
      {:ok, document} = Graphics.draw_rect(document, @draw_rect_command)
      {:ok, document} = Graphics.flood_fill(document, @flood_fill_command)
      conn = get(conn, Routes.graphics_path(conn, :show, document.id))
      assert conn.status === 200
      assert conn.resp_body === Document.to_string(document)
    end
  end

  describe "draw rectangle" do
    test "updates document when data is valid", %{conn: conn, document: document} do
      conn = post(conn, Routes.graphics_path(conn, :draw_rect, document.id), @draw_rect_command)
      assert %{"content" => [_ | _]} = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, document: document} do
      conn = post(conn, Routes.graphics_path(conn, :draw_rect, document.id), %{})
      assert %{"x" => [_ | _], "y" => [_ | _]} = json_response(conn, 422)["errors"]
    end
  end

  describe "flood fill" do
    test "updates document when data is valid", %{conn: conn, document: document} do
      conn = post(conn, Routes.graphics_path(conn, :flood_fill, document.id), @flood_fill_command)
      assert %{"content" => [_ | _]} = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, document: document} do
      conn = post(conn, Routes.graphics_path(conn, :flood_fill, document.id), %{})
      assert %{"x" => [_ | _], "y" => [_ | _]} = json_response(conn, 422)["errors"]
    end
  end
end
