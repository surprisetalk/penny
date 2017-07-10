defmodule Penny.Repo.Migrations.CreateTask.Event do
  use Ecto.Migration

  def change do
    create table(:task_events) do
      add :event, :string, default: "PENDING", null: false
      # TODO: enum: PENDING, COMPLETED, DELETED

      add :task_id, references(:tasks), null: false

      timestamps()
    end

  end
end
