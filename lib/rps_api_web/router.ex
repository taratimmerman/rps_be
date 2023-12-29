defmodule RpsApiWeb.Router do
  use RpsApiWeb, :router
  use Plug.ErrorHandler

  def handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  def handle_errors(conn, %{reason: %{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug RpsApiWeb.Auth.Pipeline
    plug RpsApiWeb.Auth.SetAccount
  end

  scope "/api", RpsApiWeb do
    pipe_through :api
    get "/", DefaultController, :index
    post "/accounts/create", AccountController, :create
    post "/accounts/sign_in", AccountController, :sign_in
  end

  scope "/api", RpsApiWeb do
    pipe_through [:api, :auth]
    get "/accounts/by_id/:id", AccountController, :show
    put "/accounts/update", AccountController, :update
    post "/accounts/refresh_session", AccountController, :refresh_session
    post "/accounts/sign_out", AccountController, :sign_out
  end
end
