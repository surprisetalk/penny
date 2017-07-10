defmodule Penny.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string, null: false
      add :body, :string, null: false
      add :kind, :string, null: false # TODO: enum
      add :urgent,    :boolean, default: false, null: false
      add :important, :boolean, default: false, null: false

      add :task_id, references(:tasks)

      timestamps()
    end

  end
end
