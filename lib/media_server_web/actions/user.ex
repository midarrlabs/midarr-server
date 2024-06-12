defmodule MediaServerWeb.Actions.User do
  require Logger

  def handle_info({:registered, _params}) do
  end

  def handle_info({:navigated, params}) do
    Logger.info(params)
  end
end
