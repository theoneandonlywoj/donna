defmodule Data.Bookmark do
  use Ecto.Schema
  import Ecto.Changeset

  alias Data.User

  schema "bookmarks" do
    field :title, :string
    field :url, :string
    field :deleted_at, :utc_datetime_usec

    belongs_to :user, User

    timestamps(inserted_at: :createdAt, updated_at: :updatedAt)
  end

  def changeset(%__MODULE__{} = user \\ %__MODULE__{}, params) do
    user
    |> cast(params, [:title, :url, :deleted_at, :user_id])
    |> validate_required([:title, :url, :user_id])
    |> foreign_key_constraint(:user_id)
    |> unique_constraint([:url, :user_id])
  end
end
