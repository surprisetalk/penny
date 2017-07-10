defmodule Penny.Repo.Migrations.CreateMode.Event do
  use Ecto.Migration

  def change do
    create table(:mode_events) do
      add :mode, :string
      add :event, :string

      timestamps()
    end

  end
end
