# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :home_page,
  ecto_repos: [HomePage.Repo]

# Configures the endpoint
config :home_page, HomePageWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: HomePageWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: HomePage.PubSub,
           adapter: Phoenix.PubSub.PG2]

#Configures guardian
config :home_page, HomePage.Accounts.Guardian,
  issuer: "home_page",
  secret_key: "rGn3EMXLqxFfJSgkMHEaLDGV7kq8LzI0t36LrXopknB774EBKd+Wl7gDG6kVIx+3"

# Configures guardian_db
config :guardian, Guardian.DB,
  repo: HomePage.Repo,
  schema_name: "guardian_tokens", #トークン管理テーブル名
  sweep_interval: 60 # default: 60 minutes(期限切れトークンの削除実行間隔)

#config :logger,
#  backends: [{LoggerFileBackend, :info}]

#config :logger, :info,
#  path: "/path/to/info.log",
#  level: :info

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures the default time zone
config :home_page,
  default_time_zone: "Asia/Tokyo"

# Configures bamboo
config :home_page, HomePage.Mailer,
       adapter: Bamboo.SMTPAdapter,
       server: "smtp.gmail.com",
       port: 587,
       username: "home.page.phoenix0405@gmail.com",
       password: "Rtgbn3fuj5",
       tls: :if_available, #can be ':always' or ':never'
       ssl: false, #can be 'true'
       retries: 1

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
