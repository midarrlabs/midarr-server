defmodule MediaServer.PeopleTest do
  use MediaServer.DataCase

  setup do
    person = %MediaServer.People{
      tmdb_id: 1234,
      name: "Existing Person",
      image: "existing_image.jpg"
    }

    {:ok, inserted_person} = MediaServer.Repo.insert(person)

    {:ok, person: inserted_person}
  end

  test "inserts a new person when it doesn't exist" do
    attrs = %{
      tmdb_id: 5678,
      name: "New Person",
      image: "new_image.jpg"
    }

    assert {:ok, new_record} = MediaServer.People.insert(attrs)
    assert new_record.tmdb_id == 5678
    assert new_record.name == "New Person"
  end

  test "updates an existing person", %{person: person} do
    updated_attrs = %{
      tmdb_id: person.tmdb_id,
      name: "Updated Name",
      image: person.image
    }

    assert {:ok, updated_record} = MediaServer.People.insert(updated_attrs)
    assert updated_record.name == "Updated Name"
    assert updated_record.tmdb_id == person.tmdb_id
  end
end
