defmodule Penny.RoomChannel do
  use Penny.Web, :channel
  @schema_meta_fields [:__meta__]

  alias Penny.Task
  alias Penny.Mode.Event

  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("tasks:get", _params, socket) do
    tasks = Task
          |> Repo.all
          |> Enum.map(&unstruct/1)

    push socket, "tasks", %{"tasks" => tasks}

    {:reply, {:ok, %{"tasks" => tasks}}, socket}
  end

  def handle_in("mode:get", _params, socket) do
    case Repo.one(from x in Event, order_by: [desc: x.id], limit: 1) do
      %Event{mode: mode} ->
        push socket, "mode", %{"mode" => mode}
        {:reply, {:ok, %{"mode" => mode}}, socket}
    end
  end

  def handle_in("mode:set", mode, socket) do
    changeset = Event.changeset(%Event{}, %{"mode" => mode, "event" => "SET"})

    case Repo.insert(changeset) do
      {:ok, %Event{mode: mode}} ->
        broadcast socket, "mode", %{"mode" => mode}
        {:noreply, socket}
      {:error, %{"errors" => errors}} ->
        {:reply, {:error, errors}, socket}
    end
  end

  def handle_in("mode:skip", _params, socket) do

    %Event{mode: mode} = Repo.one!(from x in Event, order_by: [desc: x.id], limit: 1)

    modes = [
      "FROLIC",
      "NAUGHT",
      "TIDY",
      "EXERCISE",
      "FUEL",
      "GROOM",
      "INSPIRE",
      "STRATEGIZE",
      "CREATE",
      "LEARN",
      "WORK",
      "CONNECT",
      "CONSUME",
      "REVIEW",
      "AUTOMATE",
      "JOURNAL",
      "READ",
      "SLEEP",
    ]

    mode_ = next modes, mode
    broadcast socket, "mode", %{"mode" => mode_}

    changeset = Event.changeset(%Event{}, %{"mode" => mode_, "event" => "SKIP"})

    case Repo.insert(changeset) do
      {:ok, %Event{mode: mode__}} ->
        # broadcast socket, "mode", %{"mode" => mode__}
        {:noreply, socket}
      {:error, %{"errors" => errors}} ->
        broadcast socket, "mode", %{"mode" => mode}
        {:reply, {:error, errors}, socket}
    end
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  defp next(enum, current) do
    index_ = 1 + Enum.find_index(enum, fn(val) -> val == current end) 
    Enum.fetch!(enum, rem(index_, Enum.count enum))
  end

  defp unstruct(struct) do
    association_fields = struct.__struct__.__schema__(:associations)
    waste_fields = association_fields ++ @schema_meta_fields

    struct |> Map.from_struct |> Map.drop(waste_fields)
  end
end
