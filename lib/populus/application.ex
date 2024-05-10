defmodule Populus.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PopulusWeb.Telemetry,
      Populus.Repo,
      {DNSCluster, query: Application.get_env(:populus, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Populus.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Populus.Finch},
      # Start a worker by calling: Populus.Worker.start_link(arg)
      # {Populus.Worker, arg},
      # Start to serve requests, typically the last entry
      PopulusWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Populus.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PopulusWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
