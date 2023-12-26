defmodule RpsApi.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RpsApi.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        initials: "some initials"
      })
      |> RpsApi.Users.create_user()

    user
  end
end
