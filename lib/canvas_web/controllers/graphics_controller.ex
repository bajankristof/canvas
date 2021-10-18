defmodule CanvasWeb.GraphicsController do
  use CanvasWeb, :controller

  alias Canvas.Graphics
  alias Canvas.Graphics.Document
  alias CanvasWeb.FallbackController

  action_fallback CanvasWeb.FallbackController

  def show(conn, %{"document_id" => document_id}) do
    document = Graphics.get_document!(document_id)
    text(conn, Document.to_string(document))
  end

  def draw_rect(conn, %{"document_id" => document_id}) do
    document = Graphics.get_document!(document_id)

    case Graphics.draw_rect(document, conn.body_params) do
      {:ok, document} ->
        render(conn, "show.json", document: document)

      {:error, changeset} ->
        FallbackController.call(conn, {:error, changeset})
    end
  end

  def flood_fill(conn, %{"document_id" => document_id}) do
    document = Graphics.get_document!(document_id)
    render(conn, "show.json", document: document)
  end
end
