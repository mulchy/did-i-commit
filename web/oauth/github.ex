defmodule GitHub do
    @moduledoc """
    An OAuth2 strategy for GitHub. see https://github.com/scrogson/oauth2_example
    """
    use OAuth2.Strategy

    alias OAuth2.Strategy.AuthCode

    defp config do
      [strategy: GitHub,
       site: "https://api.github.com",
       authorize_url: "https://github.com/login/oauth/authorize",
       token_url: "https://github.com/login/oauth/access_token"]
    end

    # Public API

    def client do
      Application.get_env(:did_i_commit, GitHub)
      |> Keyword.merge(config())
      |> OAuth2.Client.new()
    end

    def authorize_url!(params \\ []) do
      OAuth2.Client.authorize_url!(client(), params)
    end

    def get_token!(params \\ [], headers \\ []) do
      OAuth2.Client.get_token!(client(), params)
    end

    # Strategy Callbacks

    def authorize_url(client, params) do
      AuthCode.authorize_url(client, params)
    end

    def get_token(client, params, headers) do
      client
      |> put_header("Accept", "application/json")
      |> put_param(:client_secret, client.client_secret)
      |> AuthCode.get_token(params, headers)
    end
end
