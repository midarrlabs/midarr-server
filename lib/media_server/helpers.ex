defmodule MediaServer.Helpers do

  def some_value({:ok, value}) do
    value
  end

  def some_value(:error) do
    ""
  end

  def another_test(nil, _url_type) do
    ""
  end

  def another_test(value, url_type) do
    Map.fetch(value, url_type)
    |> some_value()
  end

  def some_test({:ok, value}, "headshot") do
    Enum.find(value, fn item -> item["coverType"] === "headshot" end)
    |> another_test("url")
  end

  def some_test({:ok, value}, type) do
    Enum.find(value, fn item -> item["coverType"] === type end)
    |> another_test("remoteUrl")
  end

  def some_test(:error, _type) do
    ""
  end
  
  def get_poster(media) do
    Map.fetch(media, "images")
    |> some_test("poster")
  end

  def get_background(media) do
    Map.fetch(media, "images")
    |> some_test("fanart")
  end
  
  def get_headshot(media) do
    Map.fetch(media, "images")
    |> some_test("headshot")
  end
end