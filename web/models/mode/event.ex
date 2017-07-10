defmodule Penny.Mode.Event do
  use Penny.Web, :model

  schema "mode_events" do
    field :mode,  :string
    field :event, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:mode, :event])
    |> validate_required([:mode, :event])
    |> validate_inclusion(:event, [ "SET", "SKIP", "CRON", "CONTEXT" ])
    # TODO: |> validate_inclusion(:mode, [])
  end
end
