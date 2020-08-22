defmodule Nerds.Repo do
  use Ecto.Repo,
    otp_app: :nerds,
    adapter: Ecto.Adapters.Postgres
end
