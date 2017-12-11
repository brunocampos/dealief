# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :dealief,
  ecto_repos: [Dealief.Repo]

# Configures the endpoint
config :dealief, DealiefWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zRC8BPBSaXYQ3fydwmF00S8a8ssDrhZlrWRSgrmG7vPCwf8+W/XuKCJzw3PfgGW0",
  render_errors: [view: DealiefWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Dealief.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
