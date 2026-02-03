defmodule ClaudeReportTest do
  use ExUnit.Case, async: false
  import Swoosh.TestAssertions

  setup do
    port =
      Application.get_env(:claude_report, :anthropic_url)
      |> URI.parse()
      |> Map.get(:port)

    bypass = Bypass.open(port: port)

    {:ok, bypass: bypass}
  end

  test "sends an email with the report", %{bypass: bypass} do
    response_body =
      Jason.encode!(%{
        "role" => "assistant",
        "content" => [
          %{
            "type" => "text",
            "text" => "I'll fetch the content from the article to analyze it."
          },
          %{"type" => "server_tool_use", "name" => "web_fetch"},
          %{"type" => "text", "text" => "Actual report goes here."}
        ]
      })

    Bypass.expect_once(bypass, fn conn ->
      assert conn.method == "POST"
      conn = Plug.Conn.put_resp_header(conn, "content-type", "application/json")

      Plug.Conn.send_resp(conn, 200, response_body)
    end)

    ClaudeReport.process_report("Hello")

    report_body =
      "I'll fetch the content from the article to analyze it.\nActual report goes here."

    assert_email_sent(subject: "Claude report", text_body: report_body)
  end

  test "in case of API errors", %{bypass: bypass} do
    Bypass.expect_once(bypass, fn conn ->
      assert conn.method == "POST"

      Plug.Conn.send_resp(conn, 400, "Error")
    end)

    ClaudeReport.process_report("Hello")

    refute_email_sent(subject: "Claude report")

    today = Date.utc_today() |> Date.to_iso8601()
    dir = "/tmp/claude_report_log/#{Mix.env()}"

    assert file = File.ls!(dir) |> Enum.find(&String.starts_with?(&1, today))

    File.rm!("#{dir}/#{file}")
  end
end
