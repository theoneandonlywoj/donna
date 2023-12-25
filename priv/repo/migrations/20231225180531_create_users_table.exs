defmodule Donna.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :email, :string, null: false
      add :password, :string, null: false
      add :deleted_at, :utc_datetime_usec, default: nil

      timestamps(inserted_at: :createdAt, updated_at: :updatedAt)
    end

    create unique_index(:users, [:email])
  end
end
