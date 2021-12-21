defmodule MediaServer.ProvidersTest do
  use MediaServer.DataCase

  alias MediaServer.Providers

  describe "sonarrs" do
    alias MediaServer.Providers.Sonarr

    import MediaServer.ProvidersFixtures

    @invalid_attrs %{api_key: nil, name: nil, url: nil}

    test "list_sonarrs/0 returns all sonarrs" do
      sonarr = sonarr_fixture()
      assert Providers.list_sonarrs() == [sonarr]
    end

    test "get_sonarr!/1 returns the sonarr with given id" do
      sonarr = sonarr_fixture()
      assert Providers.get_sonarr!(sonarr.id) == sonarr
    end

    test "create_sonarr/1 with valid data creates a sonarr" do
      valid_attrs = %{api_key: "some api_key", name: "some name", url: "some url"}

      assert {:ok, %Sonarr{} = sonarr} = Providers.create_sonarr(valid_attrs)
      assert sonarr.api_key == "some api_key"
      assert sonarr.name == "some name"
      assert sonarr.url == "some url"
    end

    test "create_sonarr/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Providers.create_sonarr(@invalid_attrs)
    end

    test "update_sonarr/2 with valid data updates the sonarr" do
      sonarr = sonarr_fixture()
      update_attrs = %{api_key: "some updated api_key", name: "some updated name", url: "some updated url"}

      assert {:ok, %Sonarr{} = sonarr} = Providers.update_sonarr(sonarr, update_attrs)
      assert sonarr.api_key == "some updated api_key"
      assert sonarr.name == "some updated name"
      assert sonarr.url == "some updated url"
    end

    test "update_sonarr/2 with invalid data returns error changeset" do
      sonarr = sonarr_fixture()
      assert {:error, %Ecto.Changeset{}} = Providers.update_sonarr(sonarr, @invalid_attrs)
      assert sonarr == Providers.get_sonarr!(sonarr.id)
    end

    test "delete_sonarr/1 deletes the sonarr" do
      sonarr = sonarr_fixture()
      assert {:ok, %Sonarr{}} = Providers.delete_sonarr(sonarr)
      assert_raise Ecto.NoResultsError, fn -> Providers.get_sonarr!(sonarr.id) end
    end

    test "change_sonarr/1 returns a sonarr changeset" do
      sonarr = sonarr_fixture()
      assert %Ecto.Changeset{} = Providers.change_sonarr(sonarr)
    end
  end
end
