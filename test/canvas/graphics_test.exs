defmodule Canvas.GraphicsTest do
  use Canvas.DataCase

  alias Canvas.Graphics

  describe "documents" do
    alias Canvas.Graphics.Document

    import Canvas.GraphicsFixtures

    @invalid_attrs %{height: nil, width: nil}

    test "list_documents/0 returns all documents" do
      document = document_fixture()
      assert Graphics.list_documents() == [document]
    end

    test "get_document!/1 returns the document with given id" do
      document = document_fixture()
      assert Graphics.get_document!(document.id) == document
    end

    test "create_document/1 with valid data creates a document" do
      valid_attrs = %{height: 42, width: 42}

      assert {:ok, %Document{} = document} = Graphics.create_document(valid_attrs)
      assert document.content == nil
      assert document.height == 42
      assert document.width == 42
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Graphics.create_document(@invalid_attrs)
    end

    test "update_document/2 with valid data updates the document" do
      document = document_fixture()
      update_attrs = %{height: 43, width: 43}

      assert {:ok, %Document{} = document} = Graphics.update_document(document, update_attrs)
      assert document.content == nil
      assert document.height == 43
      assert document.width == 43
    end

    test "update_document/2 with invalid data returns error changeset" do
      document = document_fixture()
      assert {:error, %Ecto.Changeset{}} = Graphics.update_document(document, @invalid_attrs)
      assert document == Graphics.get_document!(document.id)
    end

    test "delete_document/1 deletes the document" do
      document = document_fixture()
      assert {:ok, %Document{}} = Graphics.delete_document(document)
      assert_raise Ecto.NoResultsError, fn -> Graphics.get_document!(document.id) end
    end

    test "change_document/1 returns a document changeset" do
      document = document_fixture()
      assert %Ecto.Changeset{} = Graphics.change_document(document)
    end
  end

  describe "commands" do
    alias Canvas.Graphics.Document

    @valid_draw_rect_params %{x: 0, y: 0, width: 2, height: 1, outline: "O"}
    @valid_flood_fill_params %{x: 0, y: 0, fill: "O"}

    test "draw_rect/2 with valid params updates the document" do
      assert {:ok, document} = Graphics.create_document(%{width: 3, height: 2})
      assert {:ok, %Document{} = document} = Graphics.draw_rect(document, @valid_draw_rect_params)
      assert document.content == ["O", "O", " ", " ", " ", " "]
    end

    test "draw_rect/2 with invalid params returns error changeset" do
      assert {:ok, document} = Graphics.create_document(%{width: 16, height: 8})
      assert {:error, %Ecto.Changeset{}} = Graphics.draw_rect(document, %{})
      assert {:error, %Ecto.Changeset{}} = Graphics.draw_rect(document, %{x: 1, y: 2, width: 1, height: 1})
      assert {:error, %Ecto.Changeset{}} = Graphics.draw_rect(document, %{x: 1, y: 2, width: 1, height: 1, outline: "OO"})
      assert {:error, %Ecto.Changeset{}} = Graphics.draw_rect(document, %{x: 1, y: 2, width: 1, height: 1, fill: "OO"})
      assert {:error, %Ecto.Changeset{}} = Graphics.draw_rect(document, %{x: 1, y: 2, width: -1, height: 1, fill: "O"})
      assert {:error, %Ecto.Changeset{}} = Graphics.draw_rect(document, %{x: 1, y: 2, width: -1, height: -1, fill: "O"})
    end

    test "flood_fill/2 with valid params updates document" do
      assert {:ok, document} = Graphics.create_document(%{width: 3, height: 2})
      assert {:ok, %Document{} = document} = Graphics.flood_fill(document, @valid_flood_fill_params)
      assert document.content == ["O", "O", "O", "O", "O", "O"]
    end

    test "flood_fill/2 with invalid params returns error changeset" do
      assert {:ok, document} = Graphics.create_document(%{width: 16, height: 8})
      assert {:error, %Ecto.Changeset{}} = Graphics.flood_fill(document, %{})
      assert {:error, %Ecto.Changeset{}} = Graphics.flood_fill(document, %{x: 1, y: 2, fill: "OO"})
      assert {:error, %Ecto.Changeset{}} = Graphics.flood_fill(document, %{x: 100, y: 2, fill: "O"})
      assert {:error, %Ecto.Changeset{}} = Graphics.flood_fill(document, %{x: 1, y: 200, fill: "O"})
    end
  end
end
