defmodule Penny.Task.Event do
  use Penny.Web, :model

  schema "task_events" do
    field :event, :string, default: "PENDING"

    belongs_to :task, Penny.Task

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:event])
    |> validate_required([:event])
    |> validate_inclusion(:event, ["PENDING","COMPLETED","DELETED"])
  end
end
