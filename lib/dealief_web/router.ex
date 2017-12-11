defmodule DealiefWeb.Router do
  use DealiefWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", DealiefWeb.Api.V1, as: :api_v1 do 
    pipe_through :api
    
    resources "/users", UserController
    resources "/vendors", VendorController, only: [:index, :show]    
  end
end
