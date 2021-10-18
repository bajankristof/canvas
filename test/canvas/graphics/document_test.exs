defmodule Canvas.Graphics.DocumentTest do
  use ExUnit.Case
  doctest Canvas.Graphics.Document

  alias Canvas.Graphics.{Document, DrawRectCommand}

  @test_binary ~S(                        
                        
   @@@@@                
   @XXX@  XXXXXXXXXXXXXX
   @@@@@  XOOOOOOOOOOOOX
          XOOOOOOOOOOOOX
          XOOOOOOOOOOOOX
          XOOOOOOOOOOOOX
          XXXXXXXXXXXXXX)

  test "to_string/1 returns correct value" do
    content = explode(@test_binary)
    document = %Document{width: 24, height: 9, content: content}
    assert Document.to_string(document) == @test_binary
  end

  test "draw_canvas/1 with content nil returns document with filled content" do
    document =
      %Document{width: 2, height: 2}
      |> Document.draw_canvas()

    assert document.content === [" ", " ", " ", " "]
  end

  test "draw_canvas/1 with content other than nil returns unchanged document" do
    document = %Document{width: 2, height: 2, content: []}
    assert Document.draw_canvas(document) === document
  end

  test "draw_rect/2 with out of bounds rectangle returns unchanged document" do
    command = %DrawRectCommand{x: 0, y: 8, width: 8, height: 2, outline: "@"}
    document = %Document{width: 16, height: 8} |> Document.draw_canvas()
    new_document = Document.draw_rect(document, command)
    assert document.content === new_document.content
  end

  test "draw_rect/2 with partially out of bounds rectangle draws rectangle correctly" do
    command = %DrawRectCommand{x: -1, y: 0, width: 3, height: 3, outline: "@"}

    document =
      %Document{width: 5, height: 3} |> Document.draw_canvas() |> Document.draw_rect(command)

    assert Document.to_string(document) === ~s(@@   \n @   \n@@   )
  end

  test "draw_rect/2 with 1x1 rectangle draws rectangle correctly" do
    command = %DrawRectCommand{x: 1, y: 1, width: 1, height: 1, outline: "@"}

    document =
      %Document{width: 3, height: 3} |> Document.draw_canvas() |> Document.draw_rect(command)

    assert Document.to_string(document) === ~s(   \n @ \n   )
  end

  defp explode(binary) do
    String.replace(binary, ~r/\n/, "")
    |> String.split("", trim: true)
  end
end
