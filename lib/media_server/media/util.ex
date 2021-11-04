defmodule MediaServer.Media.Util do
    import DirWalker
  
    def get_file_paths(dir) do
        Enum.into(stream(dir, matching: ~r(.mp4|.mkv)),[])
    end
end