defmodule RpsApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RpsApiWeb.Telemetry,
      RpsApi.Repo,
      {DNSCluster, query: Application.get_env(:rps_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: RpsApi.PubSub},
      # Start a worker by calling: RpsApi.Worker.start_link(arg)
      # {RpsApi.Worker, arg},
      # Start to serve requests, typically the last entry
      RpsApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RpsApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RpsApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
