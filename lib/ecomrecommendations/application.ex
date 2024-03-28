defmodule Ecomrecommendations.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EcomrecommendationsWeb.Telemetry,
      Ecomrecommendations.Repo,
      Ecomrecommendations.FetchProducts,
      {DNSCluster, query: Application.get_env(:ecomrecommendations, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Ecomrecommendations.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Ecomrecommendations.Finch},
      # Start a worker by calling: Ecomrecommendations.Worker.start_link(arg)
      # {Ecomrecommendations.Worker, arg},
      # Start to serve requests, typically the last entry
      EcomrecommendationsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ecomrecommendations.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EcomrecommendationsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
