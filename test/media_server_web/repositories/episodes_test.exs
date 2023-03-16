defmodule MediaServer.EpisodesTest do
  use ExUnit.Case
  
  test "it should get episode path" do
    assert MediaServerWeb.Repositories.Episodes.get_episode_path("1") === "/series/Pioneer One/Season 1/Pioneer.One.S01E01.Earthfall.720p.mp4"
  end
end
