defmodule MediaServerWeb.ComponentsLive.Index do
  use MediaServerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(page_title: "Components")
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
    }
  end
end
