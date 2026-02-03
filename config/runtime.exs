import Config

config :claude_report, anthropic_api_key: System.fetch_env!("ANTHROPIC_API_KEY")

config :claude_report, ClaudeReport.Mailer,
  api_key: System.fetch_env!("MAILGUN_API_KEY"),
  domain: System.fetch_env!("MAILGUN_SANDBOX_DOMAIN")

config :claude_report,
  email: [
    from_name: System.fetch_env!("EMAIL_FROM_NAME"),
    from_address: System.fetch_env!("EMAIL_FROM_ADDRESS"),
    to_address: System.fetch_env!("EMAIL_TO_ADDRESS")
  ]
