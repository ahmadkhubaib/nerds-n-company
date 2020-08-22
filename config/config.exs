# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :nerds,
  ecto_repos: [Nerds.Repo]

# Configures the endpoint
config :nerds, NerdsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "b5Wt8zR5eCIXosTah57Gdy/HIOcpOAcf9yOt0wM1NwylQ4afE/sjffP5yc1dciRv",
  render_errors: [view: NerdsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Nerds.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :nerds, :pow,
  user: Nerds.Users.User,
  repo: Nerds.Repo

config :nerds, ExOauth2Provider,
  repo: Nerds.Repo,
  resource_owner: Nerds.Users.User

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
