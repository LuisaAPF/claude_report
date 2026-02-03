import Config

config :swoosh, api_client: Swoosh.ApiClient.Req

import_config("#{config_env()}.exs")
