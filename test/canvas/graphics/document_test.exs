defmodule Canvas.Graphics.DocumentTest do
  use ExUnit.Case
  doctest Canvas.Graphics.Document

  alias Canvas.Graphics.Document

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

  defp explode(binary) do
    String.replace(binary, ~r/\n/, "")
    |> String.split("", trim: true)
  end
end
