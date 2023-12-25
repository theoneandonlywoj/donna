defmodule Data.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :first_name, :string
    field :email, :string
    field :password, :string
    field :deleted_at, :utc_datetime_usec, default: nil

    timestamps(inserted_at: :createdAt, updated_at: :updatedAt)
  end

  def changeset(%__MODULE__{} = user \\ %__MODULE__{}, params) do
    user
    |> cast(params, [:first_name, :email, :password, :deleted_at])
    |> validate_required([:email, :password])
    |> unique_constraint(:email, name: :uniq_email)
  end
end
