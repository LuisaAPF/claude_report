# ClaudeReport

Generates a report based on a prompt by using Anthropic's web fetch tool and sends it via email.
Available reports are saved under `lib/reports`.

Run an existing report:
```
mix run -e ClaudeReport.Reports.NewElixirLibraries.report()
```


