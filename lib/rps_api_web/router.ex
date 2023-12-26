defmodule RpsApiWeb.Router do
  use RpsApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RpsApiWeb do
    pipe_through :api
    get "/", DefaultController, :index
  end
end
