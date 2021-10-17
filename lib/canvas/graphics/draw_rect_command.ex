defmodule Canvas.Graphics.DrawRectCommand do
  use Ecto.Schema
  import Ecto.Changeset
  alias Canvas.Graphics.{Document, DrawRectCommand}

  @outline_or_fill_error "one of outline or fill must be present"

  embedded_schema do
    field :fill, :string
    field :height, :integer
    field :outline, :string
    field :width, :integer
    field :x, :integer
    field :y, :integer
  end

  @doc false
  def changeset(%DrawRectCommand{} = rect_operation, attrs) do
    rect_operation
    |> cast(attrs, [:x, :y, :width, :height, :fill, :outline])
    |> validate_required([:x, :y, :width, :height])
    |> validate_length(:fill, min: 1, max: 1)
    |> validate_length(:outline, min: 1, max: 1)
    |> validate_conditionals()
  end

  def validate_inside(changeset, %Document{} = document) do
    [{:x, document.width}, {:y, document.height}]
    |> Enum.reduce(changeset, fn {attr, max}, changeset ->
      value = get_field(changeset, attr)

      if value < 1 || max < value,
        do: add_error(changeset, attr, "out of bounds (min: 1, max: #{max})"),
        else: changeset
    end)
  end

  defp validate_conditionals(changeset) do
    with false <- !!get_field(changeset, :outline),
         false <- !!get_field(changeset, :fill) do
      add_error(changeset, :outline, @outline_or_fill_error)
      |> add_error(:fill, @outline_or_fill_error)
    else
      true -> changeset
    end
  end
end
