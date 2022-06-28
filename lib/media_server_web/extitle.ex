defmodule MediaServer.Extitle do
  defp make_cue([_, timing | lines]) do
    [from, to] = timing |> String.split(" --> ")

    [
      %{
        from: Time.from_iso8601!(from),
        to: Time.from_iso8601!(to),
        text: lines
      }
    ]
  end

  def parse(path) do
    File.read!(path)
    |> String.split("\n\n", trim: true)
    |> Enum.flat_map(fn item ->
      item
      |> String.split("\n", trim: true)
      |> make_cue
    end)
  end

  defp pad(time, count \\ 2), do: "#{time}" |> String.pad_leading(count, ["0"])

  defp format_time(
         %Time{hour: hour, minute: minute, second: second, microsecond: {us, _}},
         separator
       ) do
    "#{pad(hour)}:#{pad(minute)}:#{pad(second)}#{separator}#{"#{div(us, 1000)}" |> pad(3)}"
  end

  defp build_cues(cues) do
    cues
    |> Enum.map(fn %{from: from, to: to, text: text} ->
      "#{format_time(from, ".")} --> #{format_time(to, ".")}\n" <> Enum.join(text, "\n")
    end)
    |> Enum.join("\n\n")
  end

  def format(cues) do
    "WEBVTT\n\n" <> build_cues(cues)
  end
end
