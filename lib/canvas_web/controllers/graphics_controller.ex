defmodule CanvasWeb.GraphicsController do
  use CanvasWeb, :controller

  alias Canvas.Graphics
  alias CanvasWeb.FallbackController

  action_fallback CanvasWeb.FallbackController

  def draw_rect(conn, %{"document_id" => document_id}) do
    document = Graphics.get_document!(document_id)

    case Graphics.draw_rect(document, conn.body_params) do
      {:ok, result} ->
        render(conn, "rect.json", params: result)

      {:error, changeset} ->
        FallbackController.call(conn, {:error, changeset})
    end
  end

  def flood_fill(conn, params) do
    render(conn, "fill.json", params: params)
  end
end
