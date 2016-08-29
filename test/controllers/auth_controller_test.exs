defmodule DidICommit.AuthControllerTest do
  use DidICommit.ConnCase

  alias DidICommit.Auth
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, auth_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    auth = Repo.insert! %Auth{}
    conn = get conn, auth_path(conn, :show, auth)
    assert json_response(conn, 200)["data"] == %{"id" => auth.id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, auth_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, auth_path(conn, :create), auth: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Auth, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, auth_path(conn, :create), auth: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    auth = Repo.insert! %Auth{}
    conn = put conn, auth_path(conn, :update, auth), auth: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Auth, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    auth = Repo.insert! %Auth{}
    conn = put conn, auth_path(conn, :update, auth), auth: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    auth = Repo.insert! %Auth{}
    conn = delete conn, auth_path(conn, :delete, auth)
    assert response(conn, 204)
    refute Repo.get(Auth, auth.id)
  end
end
