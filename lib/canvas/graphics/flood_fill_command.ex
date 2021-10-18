defmodule Canvas.Graphics.FloodFillCommand do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :fill, :string
    field :x, :integer
    field :y, :integer
  end

  @type t() :: %__MODULE__{}

  @doc false
  def changeset(%__MODULE__{} = fill_operation, attrs) do
    fill_operation
    |> cast(attrs, [:x, :y, :fill])
    |> validate_required([:x, :y, :fill])
    |> validate_length(:fill, min: 1, max: 1)
  end
end
