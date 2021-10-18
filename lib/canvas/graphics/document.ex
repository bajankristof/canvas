defmodule Canvas.Graphics.Document do
  use Ecto.Schema
  import Ecto.Changeset

  alias Canvas.Graphics.DrawRectCommand

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
    coord_range = coord_range(document)

    Enum.reduce(coord_range, "", fn index, acc ->
      eor? = rem(index + 1, document.width) === 0
      sod? = index === coord_range.first
      eod? = index === coord_range.last
      sep = if eor? && (!sod? && !eod?), do: "\n", else: ""
      acc <> Enum.at(document.content, index) <> sep
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
  def draw_canvas(%__MODULE__{content: nil} = document) do
    content = List.duplicate(" ", object_length(document))
    %{document | content: content}
  end

  def draw_canvas(document),
    do: document

  @doc """
  Returns `document` with a new rectangle inside its content specified by `command`.
  """
  @spec draw_rect(document :: t(), command :: DrawRectCommand.t()) :: t()
  def draw_rect(%__MODULE__{} = document, %DrawRectCommand{outline: nil} = command),
    do: draw_rect(document, %{command | outline: command.fill})

  def draw_rect(%__MODULE__{} = document, %DrawRectCommand{} = command) do
    content =
      coord_range(command)
      |> Enum.reduce(document.content, fn index, acc ->
        rel_x = rem(index, command.width)
        abs_x = rel_x + command.x
        rel_y = div(index, command.width)
        abs_y = rel_y + command.y

        if abs_x in 0..(document.width - 1) && abs_y in 0..(document.height - 1) do
          horizontal_edge? = command.height === 1 || rem(rel_y, command.height - 1) === 0
          vertical_edge? = command.width === 1 || rem(rel_x, command.width - 1) === 0
          outline? = horizontal_edge? || vertical_edge?

          char = if outline?, do: command.outline, else: command.fill
          pos = abs_x + abs_y * document.width
          if char, do: List.replace_at(acc, pos, char), else: acc
        else
          acc
        end
      end)

    %{document | content: content}
  end

  defp coord_range(object),
    do: 0..(object_length(object) - 1)

  defp object_length(%{width: width, height: height}),
    do: width * height
end
