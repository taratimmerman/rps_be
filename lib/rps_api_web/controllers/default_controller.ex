defmodule RpsApiWeb.DefaultController do
  use RpsApiWeb, :controller

  def index(conn, _params) do
    text(conn, "Rock, Paper, Scissors API is LIVE - #{Mix.env()}")
  end
end
