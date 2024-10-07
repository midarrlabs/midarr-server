defmodule MediaServer.EpisodesTest do
  use MediaServer.DataCase

  setup do
    series = %MediaServer.Series{
      sonarr_id: 4,
      tmdb_id: 1001,
      seasons: 2,
      title: "Existing Series",
      overview: "Existing overview",
      poster: "existing_poster.jpg",
      background: "existing_background.jpg"
    }

    {:ok, inserted_series} = MediaServer.Repo.insert(series)

    episode = %MediaServer.Episodes{
      series_id: inserted_series.id,
      sonarr_id: 4000,
      season: 1,
      number: 1,
      title: "Existing Episode",
      overview: "Existing overview",
      screenshot: "existing_screenshot.jpg"
    }

    {:ok, inserted_episode} = MediaServer.Repo.insert(episode)

    {:ok, series: inserted_series, episode: inserted_episode}
  end

  test "inserts a new episode when it doesn't exist", %{series: series} do
    attrs = %{
      series_id: series.id,
      sonarr_id: 4001,
      season: 1,
      number: 2,
      title: "New Episode",
      overview: "New overview",
      screenshot: "new_screenshot.jpg"
    }

    assert {:ok, new_record} = MediaServer.Episodes.insert(attrs)
    assert new_record.sonarr_id == 4001
    assert new_record.title == "New Episode"
  end

  test "updates an existing episode", %{episode: episode} do
    updated_attrs = %{
      series_id: episode.series_id,
      sonarr_id: episode.sonarr_id,
      season: episode.season,
      title: "Updated Title",
      overview: episode.overview,
      screenshot: episode.screenshot
    }

    assert {:ok, updated_record} = MediaServer.Episodes.insert(updated_attrs)
    assert updated_record.title == "Updated Title"
    assert updated_record.sonarr_id == episode.sonarr_id
  end
end
