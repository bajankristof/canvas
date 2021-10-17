defmodule CanvasWeb.DocumentView do
  use CanvasWeb, :view
  alias CanvasWeb.DocumentView

  def render("index.json", %{documents: documents}) do
    %{data: render_many(documents, DocumentView, "document.json")}
  end

  def render("show.json", %{document: document}) do
    %{data: render_one(document, DocumentView, "document.json")}
  end

  def render("document.json", %{document: document}) do
    %{
      id: document.id,
      width: document.width,
      height: document.height,
      content: document.content
    }
  end
end
