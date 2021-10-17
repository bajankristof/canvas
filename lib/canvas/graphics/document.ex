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

  def render(document) do
    0..(document.width * document.height)
    |> Enum.reduce("", fn index, acc ->
      eol? = document.width <= index && rem(index - 1, document.width) == 0
      sep = if eol?, do: "\n", else: ""
      acc <> sep <> Enum.at(document.content, index, " ")
    end)
  end
end
