defmodule Data.User.Queries do
  use Data.BaseQueries

  alias Donna.Repo
  alias Data.User

  def query(args) do
    User
    |> from(as: :entry)
    |> where([entry: s], is_nil(s.deleted_at))
    |> apply_filters(args)
  end
end
