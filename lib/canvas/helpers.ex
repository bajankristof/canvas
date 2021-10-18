defmodule Canvas.Helpers do
  @moduledoc false

  def rect_reduce(%{width: width, height: height}, acc, fun)
      when width > 0 and height > 0 do
    0..(width * height - 1)
    |> Enum.reduce(acc, fn pos, acc ->
      x = rem(pos, width)
      y = div(pos, width)
      fun.({pos, x, y}, acc)
    end)
  end

  def rect_contains?(%{width: width, height: height}, x, y),
    do: x >= 0 && x < width && y >= 0 && y < height

  def rect_edge?(%{width: width, height: height}, x, y)
      when x >= 0 and x < width and y >= 0 and y < height,
      do: width === 1 || height === 1 || rem(y, height - 1) === 0 || rem(x, width - 1) === 0

  def translate_pos(%{width: width}, x, y),
    do: x + y * width
end
