defmodule MediaServer.SeriesTest do
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

    {:ok, inserted_series} = Repo.insert(series)

    {:ok, series: inserted_series}
  end

  test "inserts a new series when it doesn't exist" do
    attrs = %{
      sonarr_id: 5,
      tmdb_id: 1002,
      seasons: 2,
      title: "New Series",
      overview: "A new overview",
      poster: "new_poster.jpg",
      background: "new_background.jpg"
    }

    assert {:ok, new_record} = MediaServer.Series.insert(attrs)
    assert new_record.sonarr_id == 5
    assert new_record.title == "New Series"
  end

  test "updates an existing series", %{series: series} do
    updated_attrs = %{
      sonarr_id: series.sonarr_id,
      tmdb_id: series.tmdb_id,
      seasons: series.seasons,
      title: "Updated Title",
      overview: series.overview,
      poster: series.poster,
      background: series.background
    }

    assert {:ok, updated_record} = MediaServer.Series.insert(updated_attrs)
    assert updated_record.title == "Updated Title"
    assert updated_record.sonarr_id == series.sonarr_id
  end
end
