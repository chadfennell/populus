defmodule Populus.Repo do
  use Ecto.Repo,
    otp_app: :populus,
    adapter: Ecto.Adapters.Postgres
end
