defmodule Canvas.GraphicsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Canvas.Graphics` context.
  """

  @doc """
  Generate a document.
  """
  def document_fixture(attrs \\ %{}) do
    {:ok, document} =
      attrs
      |> Enum.into(%{
        content: [],
        height: 42,
        width: 42
      })
      |> Canvas.Graphics.create_document()

    document
  end
end
