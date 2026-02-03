import Config

config :claude_report, anthropic_url: "http://localhost:4002"

config :claude_report, ClaudeReport.Mailer, adapter: Swoosh.Adapters.Test
