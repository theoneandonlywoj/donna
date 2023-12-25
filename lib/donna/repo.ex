defmodule Donna.Repo do
  use Ecto.Repo,
    otp_app: :donna,
    adapter: Ecto.Adapters.Postgres
end
