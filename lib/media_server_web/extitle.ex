defmodule MediaServer.Extitle do
  def make_cue([_, timing | lines]) do
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

  defp pad(time, count\\2), do: "#{time}" |> String.pad_leading(count, ["0"])

  defp format_microsecond(us), do: "#{div(us, 1000)}" |> pad(3)

  def format_time(%Time{hour: h, minute: m, second: s, microsecond: {us, _}}, sep) do
    "#{pad(h)}:#{pad(m)}:#{pad(s)}#{sep}#{format_microsecond(us)}"
  end

  defp build_cue_header(%{from: from, to: to}) do
    "#{format_time(from, ".")} --> #{format_time(to, ".")}\n"
  end

  defp build_cue_text(parts), do: parts |> Enum.map(& &1) |> Enum.join("\n")

  defp build(sub) do
    build_cue_header(sub) <> build_cue_text(sub.text)
  end

  defp build_cues(sub) do
    sub
    |> Enum.map(&build(&1))
    |> Enum.join("\n\n")
  end

  def format(cues) do
    "WEBVTT\n\n" <> build_cues(cues)
  end
end
