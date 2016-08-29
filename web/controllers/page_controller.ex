defmodule DidICommit.PageController do
  use DidICommit.Web, :controller

  def index(conn, _params) do
#    IO.puts conn.assigns.current_user.username
    result = if conn.assigns.current_user do
      {:ok, %{body: events}} = OAuth2.Client.get(get_session(conn, :client), "/users/" <> conn.assigns.current_user.username <> "/events")
      events
    end

    result = result
    |> Enum.filter(fn(%{"type" => type, "created_at" => created_at}) ->
      type == "PushEvent" &&
	Timex.Interval.new(from: Timex.now, until: [days: 1])
	|> Enum.member?(Timex.parse!(created_at, "{ISO:Extended}"))
    end)
    IO.inspect result
    render conn, "index.html", events: result
  end
end
