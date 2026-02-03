defmodule ClaudeReport do
  @moduledoc """
  Generates a report based on a prompt by using Anthropic's web fetch tool.
  Sends the report via email.

  E.g.
  ClaudeReport.process_report("Summarize the last 5 posts on https://example.com")
  """
  import Swoosh.Email
  alias ClaudeReport.Mailer

  defp fetch_report(prompt, opts) do
    model = Keyword.get(opts, :model, "claude-sonnet-4-5")
    allowed_domains = Keyword.get(opts, :allowed_domains)
    max_uses = Keyword.get(opts, :max_uses, 5)
    max_tokens = Keyword.get(opts, :max_content_tokens, 1024)
    api_key = Application.get_env(:claude_report, :anthropic_api_key)
    url = Application.get_env(:claude_report, :anthropic_url)

    headers = %{
      "x-api-key" => api_key,
      "content-type" => "application/json",
      "anthropic-beta" => "web-fetch-2025-09-10",
      "anthropic-version" => "2023-06-01"
    }

    data = %{
      "model" => model,
      "max_tokens" => max_tokens,
      "messages" => [
        %{
          "role" => "user",
          "content" => prompt
        }
      ],
      "tools" => [
        %{
          "type" => "web_fetch_20250910",
          "name" => "web_fetch",
          "max_uses" => max_uses,
          (allowed_domains && "allowed_domains") => allowed_domains
        }
      ]
    }

    Req.post(url, headers: headers, json: data)
  end

  defp send_email(text) do
    config = Application.get_env(:claude_report, :email)
    from = {Keyword.get(config, :from_name), Keyword.get(config, :from_address)}
    to = Keyword.get(config, :to_address)

    new()
    |> from(from)
    |> to(to)
    |> subject("Claude report")
    |> text_body(text)
    |> Mailer.deliver()
  end

  def process_report(prompt, opts \\ []) do
    case fetch_report(prompt, opts) do
      {:ok, %{body: body, status: 200}} ->
        report =
          Enum.filter(body["content"], fn content ->
            content["type"] == "text"
          end)
          |> Enum.map_join("\n", & &1["text"])

        send_email(report)

      {_, response} ->
        log = inspect(response)
        now = DateTime.utc_now() |> DateTime.to_iso8601()
        dir = "/tmp/claude_report_log/#{Mix.env()}"

        File.mkdir_p!(dir)
        File.write!("/#{dir}/#{now}", log)

        :error
    end
  end
end
