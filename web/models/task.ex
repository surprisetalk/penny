defmodule Penny.Task do
  use Penny.Web, :model

  schema "tasks" do
    field :name, :string
    field :body, :string
    field :kind, :string
    field :urgent, :boolean, default: false
    field :important, :boolean, default: false

    belongs_to :task, Penny.Task
    has_many :tasks, Penny.Task
    has_many :events, Penny.Task.Event

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    # |> preload([:tasks,:events])
    |> cast(params, [:name, :body, :kind, :urgent, :important, :task_id])
    |> validate_required([:name, :body, :kind, :urgent, :important])
    |> validate_inclusion(:kind, ["STUDY","PROJECT","CHORE"])
    # |> cast_assoc(:tasks)
  end
end
