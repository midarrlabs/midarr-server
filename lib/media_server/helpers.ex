defmodule MediaServer.Helpers do
  defp extract_url(nil, _), do: ""
  defp extract_url(value, key) do
    case Map.fetch(value, key) do
      {:ok, url} -> url
      _ -> ""
    end
  end

  defp find_image({:ok, images}, type) do
    images
    |> Enum.find(&(&1["coverType"] == type))
    |> extract_url("remoteUrl")
  end

  defp find_image(:error, _type), do: ""

  def get_poster(media), do: Map.fetch(media, "images") |> find_image("poster")
  def get_background(media), do: Map.fetch(media, "images") |> find_image("fanart")
  def get_headshot(media), do: Map.fetch(media, "images") |> find_image("headshot")

  def get_image_file(url) do
    Regex.run(~r([^\/]+$), url)
    |> List.first()
  end
end
