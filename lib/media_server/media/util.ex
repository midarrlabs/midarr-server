defmodule MediaServer.Media.Util do
    import DirWalker

    alias MediaServer.Media
  
    def get_file_paths(dir) do
        Enum.into(stream(dir, matching: ~r(.mp4|.mkv)),[])
    end

    def persist_file(file_path) do

        libraries = Media.list_libraries()

        library = Enum.filter(libraries, fn library -> 
            String.contains?(file_path, library.path) 
            end)

        Enum.each(library, fn library ->
            case HTTPoison.get(if System.get_env("NAME_PARSER") !== nil, do: System.get_env("NAME_PARSER")<>"#{URI.encode(file_path)}", else: "http://guessit:80/?filename="<>"#{URI.encode(file_path)}") do

                {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
                    decoded = Jason.decode!(body)

                    Media.create_file(%{path: file_path, title: decoded["title"], year: decoded["year"], library_id: library.id})

                {:ok, %HTTPoison.Response{status_code: 404}} ->
                    IO.puts "Not found :("

                {:error, %HTTPoison.Error{reason: reason}} ->
                    IO.inspect reason
            end 
        end)
  end
end