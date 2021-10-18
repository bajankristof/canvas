defmodule Canvas.Graphics do
  @moduledoc """
  The Graphics context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Changeset
  alias Canvas.Repo

  alias Canvas.Graphics.{Document, DrawRectCommand, FloodFillCommand}

  @doc """
  Returns the list of documents.

  ## Examples

      iex> list_documents()
      [%Document{}, ...]

  """
  def list_documents do
    Repo.all(Document)
  end

  @doc """
  Gets a single document.

  Raises `Ecto.NoResultsError` if the Document does not exist.

  ## Examples

      iex> get_document!(123)
      %Document{}

      iex> get_document!(456)
      ** (Ecto.NoResultsError)

  """
  def get_document!(id), do: Repo.get!(Document, id)

  @doc """
  Creates a document.

  ## Examples

      iex> create_document(%{field: value})
      {:ok, %Document{}}

      iex> create_document(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_document(attrs \\ %{}) do
    %Document{}
    |> Document.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a document.

  ## Examples

      iex> update_document(document, %{field: new_value})
      {:ok, %Document{}}

      iex> update_document(document, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_document(%Document{} = document, attrs) do
    document
    |> Document.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a document.

  ## Examples

      iex> delete_document(document)
      {:ok, %Document{}}

      iex> delete_document(document)
      {:error, %Ecto.Changeset{}}

  """
  def delete_document(%Document{} = document) do
    Repo.delete(document)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking document changes.

  ## Examples

      iex> change_document(document)
      %Ecto.Changeset{data: %Document{}}

  """
  def change_document(%Document{} = document, attrs \\ %{}) do
    Document.changeset(document, attrs)
  end

  @doc """
  Draws a rectangle in a document.

  ### Examples

      iex> draw_rect(document, params)
      {:ok, %Document{}}

      iex> draw_rect(document, params)
      {:error, %Ecto.Changeset{}}

  """
  def draw_rect(%Document{} = document, params) do
    with {:ok, command} <-
           %DrawRectCommand{}
           |> DrawRectCommand.changeset(params)
           |> Changeset.apply_action(:create),
         %{content: content} <-
           Document.draw_canvas(document)
           |> Document.draw_rect(command) do
      Document.content_changeset(document, content)
      |> Repo.update()
    else
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Flood fills an area in a document.

  ### Examples

      iex> flood_fill(document, params)
      {:ok, %Document{}}

      iex> flood_fill(document, params)
      {:error, %Ecto.Changeset{}}

  """
  def flood_fill(%Document{} = document, params) do
    with {:ok, command} <-
           %FloodFillCommand{}
           |> FloodFillCommand.changeset(params)
           |> FloodFillCommand.validate_inside(document)
           |> Changeset.apply_action(:create),
         %{content: content} <-
           Document.draw_canvas(document)
           |> Document.flood_fill(command) do
      Document.content_changeset(document, content)
      |> Repo.update()
    else
      {:error, changeset} -> {:error, changeset}
    end
  end
end
