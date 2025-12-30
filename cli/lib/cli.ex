defmodule Cli do
  @timeout_seconds 240  # 4 minutes, leaves 1 minute buffer before GitHub's 5-minute timeout

  def main(args) do
    message = Enum.join(args, " ")
    IO.puts("Running at: #{DateTime.utc_now()}")
    IO.puts("Message: #{message}")
    IO.puts("Timeout: #{@timeout_seconds}s")
    IO.puts("---")

    if message != "" do
      escaped_message = String.replace(message, "'", "'\\''")
      cmd = "timeout #{@timeout_seconds} claude -p '#{escaped_message}' --output-format text --dangerously-skip-permissions"
      {output, status} = System.shell(cmd, close_stdin: true)
      IO.write(output)

      if status == 124 do
        IO.puts("\n---")
        IO.puts("ERROR: Claude timed out after #{@timeout_seconds} seconds")
      end

      System.halt(status)
    else
      IO.puts("No message provided, skipping Claude")
    end
  end
end
