defmodule Canvas.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :width, :integer
      add :height, :integer
      add :content, {:array, :string}

      timestamps()
    end
  end
end
