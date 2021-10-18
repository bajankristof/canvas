defmodule Canvas.Graphics.DrawRectCommand do
  use Ecto.Schema
  import Ecto.Changeset

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
  def changeset(%__MODULE__{} = rect_operation, attrs) do
    rect_operation
    |> cast(attrs, [:x, :y, :width, :height, :fill, :outline])
    |> validate_required([:x, :y, :width, :height])
    |> validate_length(:fill, min: 1, max: 1)
    |> validate_length(:outline, min: 1, max: 1)
    |> validate_size(:width)
    |> validate_size(:height)
    |> validate_conditionals()
  end

  defp validate_size(changeset, attr) do
    if get_field(changeset, attr) < 0,
      do: add_error(changeset, attr, @size_error),
      else: changeset
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
