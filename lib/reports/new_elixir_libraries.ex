defmodule ClaudeReport.Reports.NewElixirLibraries do
  def report() do
    ClaudeReport.process_report(
      "Return a brief summary of the latest 5 libraries posted at https://elixirforum.com/c/your-libraries-os-mentoring/libraries/43/l/latest",
      allowed_domains: ["elixirforum.com"]
    )
  end
end
