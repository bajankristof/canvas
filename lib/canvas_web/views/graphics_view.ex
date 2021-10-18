defmodule CanvasWeb.GraphicsView do
  use CanvasWeb, :view
  alias CanvasWeb.DocumentView

  def render("show.json", %{document: document}) do
    %{data: render_one(document, DocumentView, "document.json")}
  end
end
