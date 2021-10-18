defmodule Canvas.Graphics.FloodFillCommand do
  use Ecto.Schema
  import Ecto.Changeset
  alias Canvas.Graphics.Document

  embedded_schema do
    field :fill, :string
    field :x, :integer
    field :y, :integer
  end

  @type t() :: %__MODULE__{}

  @doc false
  def changeset(%__MODULE__{} = command, attrs) do
    command
    |> cast(attrs, [:x, :y, :fill])
    |> validate_required([:x, :y, :fill])
    |> validate_length(:fill, min: 1, max: 1)
  end

  def validate_inside(changeset, %Document{} = document) do
    [{:x, document.width}, {:y, document.height}]
    |> Enum.reduce(changeset, fn {attr, max}, changeset ->
      value = get_field(changeset, attr)

      if value < 0 || max - 1 < value,
        do: add_error(changeset, attr, "out of bounds, has to be between 1 and #{max - 1}"),
        else: changeset
    end)
  end
end
