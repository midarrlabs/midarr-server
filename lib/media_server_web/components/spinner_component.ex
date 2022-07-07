defmodule MediaServerWeb.Components.SpinnerComponent do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <div class="w-12 h-12 rounded-full animate-spin border-2 border-solid border-slate-500 border-t-transparent">
    </div>
    """
  end
end
