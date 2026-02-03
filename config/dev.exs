import Config

config :claude_report, anthropic_url: "https://api.anthropic.com/v1/messages"

config :claude_report, ClaudeReport.Mailer, adapter: Swoosh.Adapters.Mailgun
