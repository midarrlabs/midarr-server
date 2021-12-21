defmodule MediaServer.Providers do
  @moduledoc """
  The Providers context.
  """

  import Ecto.Query, warn: false
  alias MediaServer.Repo

  alias MediaServer.Providers.Sonarr

  @doc """
  Returns the list of sonarrs.

  ## Examples

      iex> list_sonarrs()
      [%Sonarr{}, ...]

  """
  def list_sonarrs do
    Repo.all(Sonarr)
  end

  @doc """
  Gets a single sonarr.

  Raises `Ecto.NoResultsError` if the Sonarr does not exist.

  ## Examples

      iex> get_sonarr!(123)
      %Sonarr{}

      iex> get_sonarr!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sonarr!(id), do: Repo.get!(Sonarr, id)

  @doc """
  Creates a sonarr.

  ## Examples

      iex> create_sonarr(%{field: value})
      {:ok, %Sonarr{}}

      iex> create_sonarr(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sonarr(attrs \\ %{}) do
    %Sonarr{}
    |> Sonarr.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sonarr.

  ## Examples

      iex> update_sonarr(sonarr, %{field: new_value})
      {:ok, %Sonarr{}}

      iex> update_sonarr(sonarr, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sonarr(%Sonarr{} = sonarr, attrs) do
    sonarr
    |> Sonarr.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sonarr.

  ## Examples

      iex> delete_sonarr(sonarr)
      {:ok, %Sonarr{}}

      iex> delete_sonarr(sonarr)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sonarr(%Sonarr{} = sonarr) do
    Repo.delete(sonarr)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sonarr changes.

  ## Examples

      iex> change_sonarr(sonarr)
      %Ecto.Changeset{data: %Sonarr{}}

  """
  def change_sonarr(%Sonarr{} = sonarr, attrs \\ %{}) do
    Sonarr.changeset(sonarr, attrs)
  end
end
