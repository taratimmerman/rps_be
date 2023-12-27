defmodule RpsApiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :rps_api,
    module: RpsApiWeb.Auth.Guardian,
    error_handler: RpsApiWeb.Auth.GuardianErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
