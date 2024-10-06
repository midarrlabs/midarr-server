defmodule MediaServer.MoviesTest do
  use MediaServer.DataCase

  setup do
    movie = %MediaServer.Movies{
      radarr_id: 4,
      tmdb_id: 1001,
      title: "Existing Movie",
      overview: "Existing overview",
      poster: "existing_poster.jpg",
      background: "existing_background.jpg"
    }

    {:ok, inserted_movie} = Repo.insert(movie)

    {:ok, movie: inserted_movie}
  end

  test "inserts a new movie when it doesn't exist" do
    attrs = %{
      radarr_id: 5,
      tmdb_id: 1002,
      title: "New Movie",
      overview: "A new overview",
      poster: "new_poster.jpg",
      background: "new_background.jpg"
    }

    assert {:ok, new_record} = MediaServer.Movies.insert(attrs)
    assert new_record.radarr_id == 5
    assert new_record.title == "New Movie"
  end

  test "updates an existing movie", %{movie: movie} do
    updated_attrs = %{
      radarr_id: movie.radarr_id,
      tmdb_id: movie.tmdb_id,
      title: "Updated Title",
      overview: movie.overview,
      poster: movie.poster,
      background: movie.background
    }

    assert {:ok, updated_record} = MediaServer.Movies.insert(updated_attrs)
    assert updated_record.title == "Updated Title"
    assert updated_record.radarr_id == movie.radarr_id
  end
end
