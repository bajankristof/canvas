defmodule CanvasWeb.DocumentLive.Show do
  use CanvasWeb, :live_view

  alias Canvas.Graphics
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    PubSub.subscribe(Canvas.PubSub, "documents")
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:document, Graphics.get_document!(id))
     |> assign(:deleted, false)}
  end

  @impl true
  def handle_info({"documents", :update, document}, socket)
      when document.id === socket.assigns.document.id,
      do: {:noreply, assign(socket, :document, document)}

  def handle_info({"documents", :delete, document}, socket)
      when document.id === socket.assigns.document.id,
      do: {:noreply, assign(socket, :deleted, true)}

  def handle_info(_, socket),
    do: {:noreply, socket}
end
