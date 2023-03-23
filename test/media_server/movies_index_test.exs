defmodule MediaServer.MoviesIndexTest do
  use ExUnit.Case
  
  test "it should get movie path" do
    assert MediaServer.MoviesIndex.get_movie_path("1")  === "/library/movies/Caminandes Llama Drama (2013)/Caminandes.Llama.Drama.1080p.mp4"
  end
end
