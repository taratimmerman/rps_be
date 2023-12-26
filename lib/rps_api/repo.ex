defmodule RpsApi.Repo do
  use Ecto.Repo,
    otp_app: :rps_api,
    adapter: Ecto.Adapters.Postgres
end
