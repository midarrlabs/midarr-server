defmodule MediaServer.MockServer do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/authorize" do
    conn
    |> Plug.Conn.send_resp(200, "ok")
  end

  post "/token" do
    conn
    |> Plug.Conn.send_resp(200, Jason.encode!(%{access_token: "someAccessToken"}))
  end

  get "/user" do
    conn
    |> Plug.Conn.send_resp(200, Jason.encode!(%{name: "someName", email: "someEmail"}))
  end
end
