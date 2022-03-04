defmodule MediaServer.Watches do
  @moduledoc """
  The WatchStatuses context.
  """

  import Ecto.Query, warn: false
  alias MediaServer.Repo

  alias MediaServer.Watches.Movie

  @doc """
  Returns the list of movie_watches.

  ## Examples

      iex> list_movie_watches()
      [%Movie{}, ...]

  """
  def list_movie_watches do
    Repo.all(Movie)
  end

  @doc """
  Gets a single movie.

  Raises `Ecto.NoResultsError` if the Movie does not exist.

  ## Examples

      iex> get_movie!(123)
      %Movie{}

      iex> get_movie!(456)
      ** (Ecto.NoResultsError)

  """
  def get_movie!(id), do: Repo.get!(Movie, id)

  @doc """
  Creates a movie.

  ## Examples

      iex> create_movie(%{field: value})
      {:ok, %Movie{}}

      iex> create_movie(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_movie(attrs \\ %{}) do
    %Movie{}
    |> Movie.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a movie.

  ## Examples

      iex> update_movie(movie, %{field: new_value})
      {:ok, %Movie{}}

      iex> update_movie(movie, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_movie(%Movie{} = movie, attrs) do
    movie
    |> Movie.changeset(attrs)
    |> Repo.update()
  end

  def update_or_create_movie(attrs) do
    movie = Repo.get_by(Movie, movie_id: attrs.movie_id, user_id: attrs.user_id)

    case movie do
      nil ->
        if attrs.current_time / attrs.duration * 100 < 90 do
          create_movie(attrs)
        else
          nil
        end

      _ ->
        if attrs.current_time / attrs.duration * 100 < 90 do
          update_movie(movie, attrs)
        else
          delete_movie(movie)

          nil
        end
    end
  end

  @doc """
  Deletes a movie.

  ## Examples

      iex> delete_movie(movie)
      {:ok, %Movie{}}

      iex> delete_movie(movie)
      {:error, %Ecto.Changeset{}}

  """
  def delete_movie(%Movie{} = movie) do
    Repo.delete(movie)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking movie changes.

  ## Examples

      iex> change_movie(movie)
      %Ecto.Changeset{data: %Movie{}}

  """
  def change_movie(%Movie{} = movie, attrs \\ %{}) do
    Movie.changeset(movie, attrs)
  end

  alias MediaServer.Watches.Episode

  @doc """
  Returns the list of episode_watches.

  ## Examples

      iex> list_episode_watches()
      [%Episode{}, ...]

  """
  def list_episode_watches do
    Repo.all(Episode)
  end

  @doc """
  Gets a single episode.

  Raises `Ecto.NoResultsError` if the Episode does not exist.

  ## Examples

      iex> get_episode!(123)
      %Episode{}

      iex> get_episode!(456)
      ** (Ecto.NoResultsError)

  """
  def get_episode!(id), do: Repo.get!(Episode, id)

  @doc """
  Creates a episode.

  ## Examples

      iex> create_episode(%{field: value})
      {:ok, %Episode{}}

      iex> create_episode(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_episode(attrs \\ %{}) do
    %Episode{}
    |> Episode.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a episode.

  ## Examples

      iex> update_episode(episode, %{field: new_value})
      {:ok, %Episode{}}

      iex> update_episode(episode, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_episode(%Episode{} = episode, attrs) do
    episode
    |> Episode.changeset(attrs)
    |> Repo.update()
  end

  def update_or_create_episode(attrs) do
    episode =
      Repo.get_by(Episode,
        episode_id: attrs.episode_id,
        serie_id: attrs.serie_id,
        user_id: attrs.user_id
      )

    case episode do
      nil ->
        if attrs.current_time / attrs.duration * 100 < 90 do
          create_episode(attrs)
        else
          nil
        end

      _ ->
        if attrs.current_time / attrs.duration * 100 < 90 do
          update_episode(episode, attrs)
        else
          delete_episode(episode)

          nil
        end
    end
  end

  @doc """
  Deletes a episode.

  ## Examples

      iex> delete_episode(episode)
      {:ok, %Episode{}}

      iex> delete_episode(episode)
      {:error, %Ecto.Changeset{}}

  """
  def delete_episode(%Episode{} = episode) do
    Repo.delete(episode)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking episode changes.

  ## Examples

      iex> change_episode(episode)
      %Ecto.Changeset{data: %Episode{}}

  """
  def change_episode(%Episode{} = episode, attrs \\ %{}) do
    Episode.changeset(episode, attrs)
  end
end
