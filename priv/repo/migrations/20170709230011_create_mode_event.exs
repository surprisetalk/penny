defmodule Penny.Repo.Migrations.CreateMode.Event do
  use Ecto.Migration

  def change do
    create table(:mode_events) do
      add :mode,  :string, null: false # enum: ...
      add :event, :string, null: false # enum: set, skip, cron, context

      timestamps()
    end

  end
end
