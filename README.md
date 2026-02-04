# ClaudeReport

Generates a report based on a prompt by using Anthropic's web fetch tool and sends it via email.
Existing reports are saved under `lib/mix/tasks`.

Run an existing report:
```
mix my_task_report
```

## Cron jobs

To run a report as a cron job, create a script similar to the one below:

```bash
#!/bin/bash

cd /path_to_claude_report_repo

# Create a file exporting the environment variables necessary to run the task and source it here.
# Otherwise crontab cannot read them.
. /path_to_env_vars_file 

# Add to the `PATH` the directories that contain the executables for `elixir`, `mix` and `erl`.
# Otherwise crontab cannot find them.
export PATH=$PATH:/path_to_executables

mix my_task_report

```

Then update your crontab:

```
30 10 * * * . /path_to_bash_script >/path_to_log_file 2>&1
```

This will run the report every day at 10:30 and save any output or error to a log file.
