use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dealief, DealiefWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :dealief, Dealief.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "brunocampos",
  password: "password",
  database: "dealief_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
