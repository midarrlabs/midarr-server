defmodule MediaServer.FavouritesTest do
  use MediaServer.DataCase

  alias MediaServer.AccountsFixtures
  alias MediaServer.Favourites

  describe "movie_favourites" do
    alias MediaServer.Favourites.Movie

    import MediaServer.FavouritesFixtures

    @invalid_attrs %{
      movie_id: nil,
      title: nil,
      image_url: nil,
      user_id: nil
    }

    test "list_movie_favourites/0 returns all movie_favourites" do
      user = AccountsFixtures.user_fixture()
      movie = movie_fixture(%{user_id: user.id})
      assert Favourites.list_movie_favourites() == [movie]
    end

    test "get_movie!/1 returns the movie with given id" do
      user = AccountsFixtures.user_fixture()
      movie = movie_fixture(%{user_id: user.id})
      assert Favourites.get_movie!(movie.id) == movie
    end

    test "create_movie/1 with valid data creates a movie" do
      valid_attrs = %{
        movie_id: 42,
        title: "some title",
        image_url: "some image url",
        user_id: AccountsFixtures.user_fixture().id
      }

      assert {:ok, %Movie{} = movie} = Favourites.create_movie(valid_attrs)
      assert movie.movie_id == 42
      assert movie.title == "some title"
      assert movie.image_url == "some image url"
    end

    test "create_movie/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Favourites.create_movie(@invalid_attrs)
    end

    test "update_movie/2 with valid data updates the movie" do
      user = AccountsFixtures.user_fixture()
      movie = movie_fixture(%{user_id: user.id})

      update_attrs = %{
        movie_id: 43,
        title: "update title",
        image_url: "update image url",
        user_id: user.id
      }

      assert {:ok, %Movie{} = movie} = Favourites.update_movie(movie, update_attrs)
      assert movie.movie_id == 43
      assert movie.title == "update title"
      assert movie.image_url == "update image url"
    end

    test "update_movie/2 with invalid data returns error changeset" do
      user = AccountsFixtures.user_fixture()
      movie = movie_fixture(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Favourites.update_movie(movie, @invalid_attrs)
      assert movie == Favourites.get_movie!(movie.id)
    end

    test "delete_movie/1 deletes the movie" do
      user = AccountsFixtures.user_fixture()
      movie = movie_fixture(%{user_id: user.id})
      assert {:ok, %Movie{}} = Favourites.delete_movie(movie)
      assert_raise Ecto.NoResultsError, fn -> Favourites.get_movie!(movie.id) end
    end

    test "change_movie/1 returns a movie changeset" do
      user = AccountsFixtures.user_fixture()
      movie = movie_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Favourites.change_movie(movie)
    end
  end

  describe "serie_favourites" do
    alias MediaServer.Favourites.Serie

    import MediaServer.FavouritesFixtures

    @invalid_attrs %{
      serie_id: nil,
      title: nil,
      image_url: nil,
      user_id: nil
    }

    test "list_serie_favourites/0 returns all serie_favourites" do
      user = AccountsFixtures.user_fixture()
      serie = serie_fixture(%{user_id: user.id})
      assert Favourites.list_serie_favourites() == [serie]
    end

    test "get_serie!/1 returns the serie with given id" do
      user = AccountsFixtures.user_fixture()
      serie = serie_fixture(%{user_id: user.id})
      assert Favourites.get_serie!(serie.id) == serie
    end

    test "create_serie/1 with valid data creates a serie" do
      valid_attrs = %{
        serie_id: 42,
        title: "some title",
        image_url: "some image url",
        user_id: AccountsFixtures.user_fixture().id
      }

      assert {:ok, %Serie{} = serie} = Favourites.create_serie(valid_attrs)
      assert serie.serie_id == 42
      assert serie.title == "some title"
      assert serie.image_url == "some image url"
    end

    test "create_serie/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Favourites.create_serie(@invalid_attrs)
    end

    test "update_serie/2 with valid data updates the serie" do
      user = AccountsFixtures.user_fixture()
      serie = serie_fixture(%{user_id: user.id})

      update_attrs = %{
        serie_id: 43,
        title: "update title",
        image_url: "update image url",
        user_id: user.id
      }

      assert {:ok, %Serie{} = serie} = Favourites.update_serie(serie, update_attrs)
      assert serie.serie_id == 43
      assert serie.title == "update title"
      assert serie.image_url == "update image url"
    end

    test "update_serie/2 with invalid data returns error changeset" do
      user = AccountsFixtures.user_fixture()
      serie = serie_fixture(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Favourites.update_serie(serie, @invalid_attrs)
      assert serie == Favourites.get_serie!(serie.id)
    end

    test "delete_serie/1 deletes the serie" do
      user = AccountsFixtures.user_fixture()
      serie = serie_fixture(%{user_id: user.id})
      assert {:ok, %Serie{}} = Favourites.delete_serie(serie)
      assert_raise Ecto.NoResultsError, fn -> Favourites.get_serie!(serie.id) end
    end

    test "change_serie/1 returns a serie changeset" do
      user = AccountsFixtures.user_fixture()
      serie = serie_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Favourites.change_serie(serie)
    end
  end
end
