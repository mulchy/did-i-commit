defmodule DidICommit.AuthController do
  use DidICommit.Web, :controller

  alias DidICommit.Auth

  def index(conn, _params) do
    redirect conn, external: GitHub.authorize_url!
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(conn, %{"code" => code}) do
    client = GitHub.get_token!(code: code)
    user = get_user!(client)
    
    conn
    |> put_session(:current_user, user)
    |> put_session(:client, client)
    |> redirect(to: "/")
  end
  
  defp get_user!(client) do
    {:ok, %{body: user}} = OAuth2.Client.get(client, "/user")
    %{name: user["name"], avatar: user["avatar_url"], username: user["login"]}
  end
end
