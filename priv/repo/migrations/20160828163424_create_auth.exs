defmodule DidICommit.Repo.Migrations.CreateAuth do
  use Ecto.Migration

  def change do
    create table(:auth) do

      timestamps()
    end

  end
end
