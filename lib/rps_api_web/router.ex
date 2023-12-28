defmodule RpsApiWeb.Router do
  use RpsApiWeb, :router
  use Plug.ErrorHandler

  defp handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  defp handle_errors(conn, %{reason: %{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug RpsApiWeb.Auth.Pipeline
  end

  scope "/api", RpsApiWeb do
    pipe_through :api
    get "/", DefaultController, :index
    post "/accounts/create", AccountController, :create
    post "/accounts/sign-in", AccountController, :sign_in
  end

  scope "/api", RpsApiWeb do
    pipe_through [:api, :auth]
    get "/accounts/by_id/:id", AccountController, :show
    put "/accounts/update", AccountController, :update
  end
end
