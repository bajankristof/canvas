defmodule CanvasWeb.DocumentLive.Index do
  use CanvasWeb, :live_view

  alias Canvas.Graphics
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    PubSub.subscribe(Canvas.PubSub, "documents")
    {:ok, assign(socket, :documents, list_documents())}
  end

  @impl true
  def handle_info({"documents", :insert, document}, socket) do
    documents = [document | socket.assigns.documents]
    {:noreply, assign(socket, :documents, documents)}
  end

  def handle_info({"documents", :delete, document}, socket) do
    documents = Enum.reject(socket.assigns.documents, &(&1.id === document.id))
    {:noreply, assign(socket, :documents, documents)}
  end

  def handle_info(_, socket),
    do: {:noreply, socket}

  defp list_documents do
    Graphics.list_documents()
  end
end
