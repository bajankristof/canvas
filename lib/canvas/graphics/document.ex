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

  @doc """
  Renders the document into its string representation.

  ### Examples

      iex> alias Canvas.Graphics.Document
      Canvas.Graphics.Document
      iex> Document.to_string(%Document{width: 3, height: 3, content: ["X", "X", "X", "X", "@", "X", "X", "X", "X"]})
      ~S(XXX
      X@X
      XXX)

  """
  def to_string(document) do
    render_range = 0..(document.width * document.height - 1)

    Enum.reduce(render_range, "", fn index, acc ->
      eor? = rem(index + 1, document.width) === 0
      sod? = index === render_range.first
      eod? = index === render_range.last
      sep = if eor? && (!sod? && !eod?), do: "\n", else: ""
      acc <> Enum.at(document.content, index) <> sep
    end)
  end
end
