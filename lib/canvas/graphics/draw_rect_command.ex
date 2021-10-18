defmodule Canvas.Graphics.DrawRectCommand do
  use Ecto.Schema
  import Kernel, except: [apply: 2]
  import Ecto.Changeset
  import Canvas.Helpers

  alias Canvas.Graphics.Document

  @outline_or_fill_error "one of outline or fill must be present"
  @size_error "has to be greater than 0"

  embedded_schema do
    field :fill, :string
    field :height, :integer
    field :outline, :string
    field :width, :integer
    field :x, :integer
    field :y, :integer
  end

  @type t() :: %__MODULE__{}

  @doc false
  def apply(%__MODULE__{outline: nil} = command, document),
    do: apply(%{command | outline: command.fill}, document)

  def apply(%__MODULE__{} = command, %Document{} = document) do
    content =
      rect_reduce(command, document.content, fn {_, x, y}, acc ->
        pos = translate_pos(document, x + command.x, y + command.y)
        type = if rect_edge?(command, x, y), do: :outline, else: :fill
        char = Map.get(command, type)

        if char && rect_contains?(document, x + command.x, y + command.y),
          do: List.replace_at(acc, pos, char),
          else: acc
      end)

    %{document | content: content}
  end

  @doc false
  def changeset(%__MODULE__{} = command, attrs) do
    command
    |> cast(attrs, [:x, :y, :width, :height, :fill, :outline])
    |> validate_required([:x, :y, :width, :height])
    |> validate_length(:fill, min: 1, max: 1)
    |> validate_length(:outline, min: 1, max: 1)
    |> validate_size(:width)
    |> validate_size(:height)
    |> validate_conditionals()
  end

  @doc false
  defp validate_size(changeset, attr) do
    if get_field(changeset, attr) < 0,
      do: add_error(changeset, attr, @size_error),
      else: changeset
  end

  @doc false
  def validate_conditionals(changeset) do
    with false <- !!get_field(changeset, :outline),
         false <- !!get_field(changeset, :fill) do
      add_error(changeset, :outline, @outline_or_fill_error)
      |> add_error(:fill, @outline_or_fill_error)
    else
      true -> changeset
    end
  end
end
