defmodule DealiefWeb.Router do
  use DealiefWeb, :router

  pipeline :api_public do
    plug :accepts, ["json"]
  end

  pipeline :api_restricted do
    plug :accepts, ["json"]
  end

  scope "/api/v1", DealiefWeb.Api.V1, as: :api_v1 do 
    pipe_through :api_public
    
    resources "/users", UserController, only: [:index, :create]
    resources "/vendors", VendorController, only: [:index, :show]
    post "/login", AuthController, :create   
  end

  scope "/api/v1", DealiefWeb.Api.V1, as: :api_v1 do 
    pipe_through :api_restricted
    
    resources "/users", UserController,  only: [:show, :update, :delete]
    resources "/contracts", ContractController    
  end
end
