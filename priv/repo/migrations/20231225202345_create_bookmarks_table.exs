defmodule Donna.Repo.Migrations.CreateBookmarksTable do
  use Ecto.Migration

  def change do
    create table(:bookmarks) do
      add :title, :string, null: false
      add :url, :string, null: false
      add :deleted_at, :utc_datetime_usec, default: nil

      add :user_id, references(:users, on_delete: :nothing)

      timestamps(inserted_at: :createdAt, updated_at: :updatedAt)
    end

    create unique_index(:bookmarks, [:url, :user_id])
  end
end
