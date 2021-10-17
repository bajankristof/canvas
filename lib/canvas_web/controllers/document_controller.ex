defmodule CanvasWeb.DocumentController do
  use CanvasWeb, :controller

  alias Canvas.Graphics
  alias Canvas.Graphics.Document

  action_fallback CanvasWeb.FallbackController

  def index(conn, _params) do
    documents = Graphics.list_documents()
    render(conn, "index.json", documents: documents)
  end

  def create(conn, %{"document" => document_params}) do
    with {:ok, %Document{} = document} <- Graphics.create_document(document_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.document_path(conn, :show, document))
      |> render("show.json", document: document)
    end
  end

  def show(conn, %{"id" => id}) do
    document = Graphics.get_document!(id)
    render(conn, "show.json", document: document)
  end

  def update(conn, %{"id" => id, "document" => document_params}) do
    document = Graphics.get_document!(id)

    with {:ok, %Document{} = document} <- Graphics.update_document(document, document_params) do
      render(conn, "show.json", document: document)
    end
  end

  def delete(conn, %{"id" => id}) do
    document = Graphics.get_document!(id)

    with {:ok, %Document{}} <- Graphics.delete_document(document) do
      send_resp(conn, :no_content, "")
    end
  end
end
