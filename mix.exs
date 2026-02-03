defmodule ClaudeReport.MixProject do
  use Mix.Project

  def project do
    [
      app: :claude_report,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.5.17"},
      {:swoosh, "~> 1.21"},
      # swoosh dependency
      {:multipart, "~> 0.6"},
      {:plug, "~>1.19"},
      {:bypass, "~>2.1", only: :test}
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
