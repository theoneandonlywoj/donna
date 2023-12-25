defmodule Data.User.Commands do
  alias Donna.Repo

  alias Data.User

  def create(args) do
    %User{}
    |> User.changeset(args)
    |> Repo.insert()
  end
end
