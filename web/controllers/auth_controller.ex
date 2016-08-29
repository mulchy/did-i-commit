defmodule DidICommit.AuthController do
  use DidICommit.Web, :controller

  alias DidICommit.Auth

  def index(conn, _params) do
    redirect conn, external: GitHub.authorize_url!
  end

  def delete(conn, %{"id" => id}) do
    auth = Repo.get!(Auth, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(auth)

    send_resp(conn, :no_content, "")
  end

  def callback(conn, %{"code" => code}) do
    client = GitHub.get_token!(code: code)
    user = get_user!(client)
    notifications = get_notifications!(client)
    
    conn
    |> put_session(:current_user, user)
    |> put_session(:client, client)
    |> put_session(:notifications, notifications)
    |> redirect(to: "/")
  end
  
  # TODO look into this more
  defp get_user!(client) do
    {:ok, %{body: user}} = OAuth2.Client.get(client, "/user")
    %{name: user["name"], avatar: user["avatar_url"], username: user["login"]}
  end

  defp get_notifications!(client) do
    {:ok, %{body: notifications}} = OAuth2.Client.get(client, "/notifications")
    notifications
  end
end
