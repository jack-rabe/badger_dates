defmodule BadgerDates.Repo do
  use Ecto.Repo,
    otp_app: :badger_dates,
    adapter: Ecto.Adapters.Postgres
end
