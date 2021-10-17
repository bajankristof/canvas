defmodule Canvas.Graphics.DocumentTest do
  use ExUnit.Case

  alias Canvas.Graphics.Document

  @test_binary ~S(                        
                        
   @@@@@                
   @XXX@  XXXXXXXXXXXXXX
   @@@@@  XOOOOOOOOOOOOX
          XOOOOOOOOOOOOX
          XOOOOOOOOOOOOX
          XOOOOOOOOOOOOX
          XXXXXXXXXXXXXX)

  test "render/1 returns correct value" do
    content = explode(@test_binary)
    document = %Document{width: 24, height: 9, content: content}
    assert Document.render(document) == @test_binary
  end

  defp explode(binary) do
    String.replace(binary, ~r/\n/, "")
    |> String.split("")
  end
end
