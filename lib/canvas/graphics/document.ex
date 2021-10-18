defmodule Canvas.Graphics.Document do
  use Ecto.Schema
  import Ecto.Changeset
  import Canvas.Helpers

  alias Canvas.Graphics.{DrawRectCommand, FloodFillCommand}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "documents" do
    field :content, {:array, :string}
    field :height, :integer
    field :width, :integer

    timestamps()
  end

  @type t() :: %__MODULE__{}

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:width, :height])
    |> validate_required([:width, :height])
  end

  @doc false
  def content_changeset(document, content) do
    cast(document, %{content: content}, [:content])
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
  @spec to_string(document :: t()) :: String.t()
  def to_string(%__MODULE__{content: nil}),
    do: ""

  def to_string(%__MODULE__{} = document) do
    rect_reduce(document, "", fn {pos, x, y}, acc ->
      sep = if x === 0 and y !== 0, do: "\n", else: ""
      acc <> sep <> Enum.at(document.content, pos)
    end)
  end

  @doc """
  Returns `document` with drawn content if content was `nil`.

  ### Examples

      iex> alias Canvas.Graphics.Document
      Canvas.Graphics.Document
      iex> Document.draw_canvas(%Document{width: 2, height: 2})
      %Document{width: 2, height: 2, content: [" ", " ", " ", " "]}

  """
  @spec draw_canvas(document :: t()) :: t()
  def draw_canvas(%__MODULE__{content: nil, width: width, height: height} = document) do
    content = List.duplicate(" ", width * height)
    %{document | content: content}
  end

  def draw_canvas(document),
    do: document

  @doc """
  Returns `document` with a new rectangle inside its content specified by `command`.
  """
  @spec draw_rect(document :: t(), command :: DrawRectCommand.t()) :: t()
  def draw_rect(%__MODULE__{} = document, %DrawRectCommand{} = command),
    do: DrawRectCommand.apply(command, document)

  @doc """
  Returns `document` with its content flood filled specified by `command`.
  """
  @spec flood_fill(document :: t(), command :: FloodFillCommand.t()) :: t()
  def flood_fill(%__MODULE__{} = document, %FloodFillCommand{} = command),
    do: FloodFillCommand.apply(command, document)
end
