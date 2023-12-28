defmodule RpsApiWeb.AccountController do
  use RpsApiWeb, :controller

  alias RpsApiWeb.{Auth.Guardian, Auth.ErrorResponse}
  alias RpsApi.{Accounts, Accounts.Account, Users, Users.User}

  plug :is_authorized_account when action in [:update, :delete]

  action_fallback RpsApiWeb.FallbackController

  defp is_authorized_account(conn, _opts) do
    %{params: %{"account" => params}} = conn
    body_id = conn.body_params["account"]["id"]
    account = Accounts.get_account!(params["id"])

    if body_id == account.id do
      conn
    else
      raise ErrorResponse.Forbidden
    end
  end

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  @spec create(any(), map()) :: any()
  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(account),
         {:ok, %User{} = _user} <- Users.create_user(account, account_params) do
      conn
      |> put_status(:created)
      |> render(:account_token, %{account: account, token: token})
    end
  end

  def sign_in(conn, %{"email" => email, "hash_password" => hash_password}) do
    case Guardian.authenticate(email, hash_password) do
      {:ok, account, token} ->
        conn
        |> put_status(:ok)
        |> render(:account_token, %{account: account, token: token})

      {:error, :unauthorized} ->
        raise ErrorResponse.Unauthorized,
          message: "Unable to complete sign-in. Please check your credentials and try again."
    end
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, :show, account: account)
  end

  def update(conn, %{"account" => account_params}) do
    account = Accounts.get_account!(account_params["id"])

    with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
      render(conn, :show, account: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
