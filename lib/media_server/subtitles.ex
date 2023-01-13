defmodule MediaServer.Subtitles do
  def remove_extension_from(file_name) do
    Regex.replace(~r/\.[^.]*$/, file_name, "")
  end

  def get_file_name(full_path) do
    Path.basename(full_path)
  end

  def get_parent_path(full_path) do
    Path.dirname(full_path)
  end

  def get_subtitle(path, file_name) do
    File.ls!(path)
    |> Enum.filter(fn item -> String.contains?(item, remove_extension_from(file_name)) end)
    |> Enum.filter(fn item -> String.contains?(item, ".srt") end)
    |> List.first()
  end

  def has_subtitle(path, file_name) do
    !is_nil(get_subtitle(path, file_name))
  end

  def handle_subtitle(nil, _parent_folder) do
    nil
  end

  def handle_subtitle(subtitle, parent_folder) do
    "#{parent_folder}/#{subtitle}"
  end
end
