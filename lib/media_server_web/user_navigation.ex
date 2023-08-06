defmodule MediaServerWeb.UserNavigation do
  def init(opts), do: opts

  def call(conn, _opts) do

    IO.puts("#{ conn.assigns[:current_user].name } navigated to: #{ conn.request_path }")

    conn
  end
end
