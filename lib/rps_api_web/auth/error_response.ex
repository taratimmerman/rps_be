defmodule RpsApiWeb.Auth.ErrorResponse.Unauthorized do
  defexception message: "Unauthorized", plug_status: 401
end

defmodule RpsApiWeb.Auth.ErrorResponse.Forbidden do
  defexception message: "No access", plug_status: 403
end
