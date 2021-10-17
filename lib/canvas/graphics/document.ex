defmodule Canvas.Graphics.Document do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "documents" do
    field :content, {:array, :string}
    field :height, :integer
    field :width, :integer

    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:width, :height])
    |> validate_required([:width, :height])
  end
end
