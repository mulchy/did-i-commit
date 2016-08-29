defmodule DidICommit.PageController do
  use DidICommit.Web, :controller

  def index(conn, _params) do
    result = if conn.assigns.current_user do
      today = Timex.now
      #TODO need to get timezone info from client
      timezone = Timex.Timezone.get("America/Chicago", today)
      today = Timex.Timezone.convert(today, timezone)
      today = Timex.beginning_of_day(today)
      tomorrow = Timex.end_of_day(today)

      # IO.inspect today
      # IO.inspect tomorrow

      {:ok, %{body: events}} = OAuth2.Client.get(get_session(conn, :client), "/users/" <> conn.assigns.current_user.username <> "/events")
      events
      |> Enum.filter(fn(%{"type" => type, "created_at" => created_at}) ->	
	created_at = Timex.Timezone.convert(Timex.parse!(created_at, "{ISO:Extended}"), timezone)
	type == "PushEvent" && Timex.between?(created_at, today, tomorrow)
      end)
    end
    
    render conn, "index.html", commit: !Enum.empty?(result || [])
  end
end
