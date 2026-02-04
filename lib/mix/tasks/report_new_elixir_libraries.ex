defmodule Mix.Tasks.ReportNewElixirLibraries do
  @requirements ["app.config", "loadpaths", "app.start"]
  use Mix.Task

  def run(_) do
    ClaudeReport.process_report(
      "Return a brief summary of the latest 5 libraries posted at https://elixirforum.com/c/your-libraries-os-mentoring/libraries/43/l/latest",
      allowed_domains: ["elixirforum.com"]
    )
  end
end
