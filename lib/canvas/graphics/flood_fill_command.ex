defmodule Canvas.Graphics.FloodFillCommand do
  use Ecto.Schema
  import Ecto.Changeset
  alias Canvas.Graphics.FloodFillCommand

  embedded_schema do
    field :fill, :string
    field :x, :integer
    field :y, :integer
  end

  @doc false
  def changeset(%FloodFillCommand{} = fill_operation, attrs) do
    fill_operation
    |> cast(attrs, [:x, :y, :fill])
    |> validate_required([:x, :y, :fill])
    |> validate_length(:fill, min: 1, max: 1)
  end
end
