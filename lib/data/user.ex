defmodule Data.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Data.Bookmark

  schema "users" do
    field :first_name, :string
    field :email, :string
    field :password, :string
    field :deleted_at, :utc_datetime_usec, default: nil

    has_many :bookmarks, Bookmark, where: [deleted_at: nil]

    has_many :deleted_bookmarks, Bookmark, where: [deleted_at: {:not, nil}]

    timestamps(inserted_at: :createdAt, updated_at: :updatedAt)
  end

  def changeset(%__MODULE__{} = user \\ %__MODULE__{}, params) do
    user
    |> cast(params, [:first_name, :email, :password, :deleted_at])
    |> validate_required([:first_name, :email, :password])
    |> unique_constraint(:email, name: :uniq_email)
  end
end
