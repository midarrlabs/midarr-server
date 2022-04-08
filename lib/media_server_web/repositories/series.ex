defmodule MediaServerWeb.Repositories.Series do
  def get_url(url) do
    case Application.get_env(:media_server, :series_base_url) === nil ||
           Application.get_env(:media_server, :series_api_key) === nil do
      true ->
        :error

      false ->
        "#{Application.get_env(:media_server, :series_base_url)}/api/v3/#{url}?apikey=#{Application.get_env(:media_server, :series_api_key)}"
    end
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Jason.decode!(body)
  end

  def handle_response({:error, %HTTPoison.Error{id: nil, reason: :nxdomain}}) do
    []
  end

  def get_latest(amount) do
    HTTPoison.get(get_url("series"))
    |> handle_response()
    |> Enum.sort_by(& &1["added"], :desc)
    |> Enum.filter(fn item -> item["statistics"]["episodeFileCount"] !== 0 end)
    |> Enum.take(amount)
  end

  def get_all() do
    HTTPoison.get(get_url("series"))
    |> handle_response()
    |> Enum.sort_by(& &1["title"], :asc)
    |> Enum.filter(fn item -> item["statistics"]["episodeFileCount"] !== 0 end)
  end

  def get_serie(id) do
    HTTPoison.get(get_url("series/#{id}"))
    |> handle_response()
  end

  def get_poster(serie) do
    (Enum.filter(serie["images"], fn item -> item["coverType"] === "poster" end)
     |> Enum.at(0))["remoteUrl"]
  end

  def get_background(serie) do
    (Enum.filter(serie["images"], fn item -> item["coverType"] === "fanart" end)
     |> Enum.at(0))["remoteUrl"]
  end
end
