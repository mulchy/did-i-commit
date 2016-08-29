defmodule DidICommit.Router do
  use DidICommit.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DidICommit do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/auth", DidICommit do
    pipe_through :browser

    get "/", AuthController, :index
    get "/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  defp assign_current_user(conn, _) do
    assign(conn, :current_user, get_session(conn, :current_user))
  end

  # Other scopes may use custom stacks.
  # scope "/api", DidICommit do
  #   pipe_through :api
  # end
end
