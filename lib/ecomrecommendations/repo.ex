defmodule Ecomrecommendations.Repo do
  use Ecto.Repo,
    otp_app: :ecomrecommendations,
    adapter: Ecto.Adapters.Postgres
end
