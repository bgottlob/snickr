defmodule Snickr.Repo do
  use Ecto.Repo,
    otp_app: :snickr,
    adapter: Ecto.Adapters.Postgres
end
