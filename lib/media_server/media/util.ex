defmodule MediaServer.Media.Util do
    import DirWalker
  
    def get_supported_files(dir) do
        Enum.into(stream(dir, matching: ~r(.mp4)),[])
    end
end