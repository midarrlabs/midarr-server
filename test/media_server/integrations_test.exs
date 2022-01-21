defmodule MediaServer.IntegrationsTest do
  use MediaServer.DataCase

  alias MediaServer.Integrations

  describe "sonarrs" do
    alias MediaServer.Integrations.Sonarr

    import MediaServer.IntegrationsFixtures

    @invalid_attrs %{api_key: nil, name: nil, url: nil}

    test "list_sonarrs/0 returns all sonarrs" do
      sonarr = sonarr_fixture()
      assert Integrations.list_sonarrs() == [sonarr]
    end

    test "get_sonarr!/1 returns the sonarr with given id" do
      sonarr = sonarr_fixture()
      assert Integrations.get_sonarr!(sonarr.id) == sonarr
    end

    test "create_sonarr/1 with valid data creates a sonarr" do
      valid_attrs = %{api_key: "some api_key", name: "some name", url: "some url"}

      assert {:ok, %Sonarr{} = sonarr} = Integrations.create_sonarr(valid_attrs)
      assert sonarr.api_key == "some api_key"
      assert sonarr.name == "some name"
      assert sonarr.url == "some url"
    end

    test "create_sonarr/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Integrations.create_sonarr(@invalid_attrs)
    end

    test "update_sonarr/2 with valid data updates the sonarr" do
      sonarr = sonarr_fixture()
      update_attrs = %{api_key: "some updated api_key", name: "some updated name", url: "some updated url"}

      assert {:ok, %Sonarr{} = sonarr} = Integrations.update_sonarr(sonarr, update_attrs)
      assert sonarr.api_key == "some updated api_key"
      assert sonarr.name == "some updated name"
      assert sonarr.url == "some updated url"
    end

    test "update_sonarr/2 with invalid data returns error changeset" do
      sonarr = sonarr_fixture()
      assert {:error, %Ecto.Changeset{}} = Integrations.update_sonarr(sonarr, @invalid_attrs)
      assert sonarr == Integrations.get_sonarr!(sonarr.id)
    end

    test "delete_sonarr/1 deletes the sonarr" do
      sonarr = sonarr_fixture()
      assert {:ok, %Sonarr{}} = Integrations.delete_sonarr(sonarr)
      assert_raise Ecto.NoResultsError, fn -> Integrations.get_sonarr!(sonarr.id) end
    end

    test "change_sonarr/1 returns a sonarr changeset" do
      sonarr = sonarr_fixture()
      assert %Ecto.Changeset{} = Integrations.change_sonarr(sonarr)
    end
  end

  describe "radarrs" do
    alias MediaServer.Integrations.Radarr

    import MediaServer.IntegrationsFixtures

    @invalid_attrs %{api_key: nil, name: nil, url: nil}

    test "list_radarrs/0 returns all radarrs" do
      radarr = radarr_fixture()
      assert Integrations.list_radarrs() == [radarr]
    end

    test "get_radarr!/1 returns the radarr with given id" do
      radarr = radarr_fixture()
      assert Integrations.get_radarr!(radarr.id) == radarr
    end

    test "get_first_radarr/0 returns radarr" do
      radarr = radarr_fixture()
      assert Integrations.get_first_radarr() == radarr
    end

    test "create_radarr/1 with valid data creates a radarr" do
      valid_attrs = %{api_key: "some api_key", name: "some name", url: "some url"}

      assert {:ok, %Radarr{} = radarr} = Integrations.create_radarr(valid_attrs)
      assert radarr.api_key == "some api_key"
      assert radarr.name == "some name"
      assert radarr.url == "some url"
    end

    test "create_radarr/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Integrations.create_radarr(@invalid_attrs)
    end

    test "update_radarr/2 with valid data updates the radarr" do
      radarr = radarr_fixture()
      update_attrs = %{api_key: "some updated api_key", name: "some updated name", url: "some updated url"}

      assert {:ok, %Radarr{} = radarr} = Integrations.update_radarr(radarr, update_attrs)
      assert radarr.api_key == "some updated api_key"
      assert radarr.name == "some updated name"
      assert radarr.url == "some updated url"
    end

    test "update_radarr/2 with invalid data returns error changeset" do
      radarr = radarr_fixture()
      assert {:error, %Ecto.Changeset{}} = Integrations.update_radarr(radarr, @invalid_attrs)
      assert radarr == Integrations.get_radarr!(radarr.id)
    end

    test "update_or_create_radarr/1 with valid data creates a radarr" do
      valid_attrs = %{api_key: "some api_key", name: "some name", url: "some url"}

      assert {:ok, %Radarr{} = radarr} = Integrations.update_or_create_radarr(valid_attrs)
      assert radarr.api_key == "some api_key"
      assert radarr.name == "some name"
      assert radarr.url == "some url"
    end

    test "update_or_create_radarr/1 with valid data updates a radarr" do
      _radarr = radarr_fixture()
      update_attrs = %{api_key: "some updated api_key", name: "some updated name", url: "some updated url"}

      assert {:ok, %Radarr{} = radarr} = Integrations.update_or_create_radarr(update_attrs)
      assert radarr.api_key == "some updated api_key"
      assert radarr.name == "some updated name"
      assert radarr.url == "some updated url"
    end

    test "delete_radarr/1 deletes the radarr" do
      radarr = radarr_fixture()
      assert {:ok, %Radarr{}} = Integrations.delete_radarr(radarr)
      assert_raise Ecto.NoResultsError, fn -> Integrations.get_radarr!(radarr.id) end
    end

    test "change_radarr/1 returns a radarr changeset" do
      radarr = radarr_fixture()
      assert %Ecto.Changeset{} = Integrations.change_radarr(radarr)
    end
  end
end
