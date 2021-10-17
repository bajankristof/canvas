defmodule CanvasWeb.GraphicsView do
  use CanvasWeb, :view

  def render("rect.json", %{params: params}) do
    %{data: params}
  end

  def render("fill.json", %{params: params}) do
    %{data: params}
  end
end
