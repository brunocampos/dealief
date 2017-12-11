defmodule DealiefWeb.Router do
  use DealiefWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DealiefWeb do
    pipe_through :api
  end
end
