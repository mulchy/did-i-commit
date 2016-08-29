defmodule DidICommit.AuthView do
  use DidICommit.Web, :view

  def render("index.json", %{auth: auth}) do
    %{data: render_many(auth, DidICommit.AuthView, "auth.json")}
  end

  def render("show.json", %{auth: auth}) do
    %{data: render_one(auth, DidICommit.AuthView, "auth.json")}
  end

  def render("auth.json", %{auth: auth}) do
    %{id: auth.id}
  end
end
