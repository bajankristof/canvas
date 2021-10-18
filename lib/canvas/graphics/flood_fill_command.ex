defmodule Canvas.Graphics.FloodFillCommand do
  use Ecto.Schema
  import Kernel, except: [apply: 2]
  import Ecto.Changeset
  import Canvas.Helpers
  alias Canvas.Graphics.Document

  embedded_schema do
    field :fill, :string
    field :x, :integer
    field :y, :integer
  end

  @type t() :: %__MODULE__{}

  @doc false
  def apply(%__MODULE__{x: x, y: y, fill: fill}, %Document{} = document) do
    pos = translate_pos(document, x, y)
    ref = Enum.at(document.content, pos)
    point = {x, y}

    if ref !== fill,
      do: do_apply([point], MapSet.new([point]), ref, fill, document),
      else: document
  end

  @doc false
  def changeset(%__MODULE__{} = command, attrs) do
    command
    |> cast(attrs, [:x, :y, :fill])
    |> validate_required([:x, :y, :fill])
    |> validate_length(:fill, min: 1, max: 1)
  end

  @doc false
  def validate_inside(changeset, %Document{} = document) do
    [{:x, document.width}, {:y, document.height}]
    |> Enum.reduce(changeset, fn {attr, max}, changeset ->
      value = get_field(changeset, attr)

      if value < 0 || max - 1 < value,
        do: add_error(changeset, attr, "out of bounds, has to be between 1 and #{max - 1}"),
        else: changeset
    end)
  end

  #############################
  # FLOOD FILL IMPLEMENTATION #
  #############################

  defp do_apply([], _, _, _, document),
    do: document

  defp do_apply([{x, y} | queue], tracker, ref, fill, document) do
    with true <- rect_contains?(document, x, y),
         pos <- translate_pos(document, x, y),
         char <- Enum.at(document.content, pos),
         true <- char === ref do
      content = List.replace_at(document.content, pos, fill)
      {queue, tracker} = enqueue_adjacent({x, y}, queue, tracker)
      do_apply(queue, tracker, ref, fill, %{document | content: content})
    else
      false ->
        do_apply(queue, tracker, ref, fill, document)
    end
  end

  defp enqueue_adjacent({x, y}, queue, tracker) do
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    |> Enum.reduce({queue, tracker}, fn point, {queue, tracker} ->
      enqueue_point(point, queue, tracker)
    end)
  end

  defp enqueue_point(point, queue, tracker) do
    if !MapSet.member?(tracker, point),
      do: {[point | queue], MapSet.put(tracker, point)},
      else: {queue, tracker}
  end
end
