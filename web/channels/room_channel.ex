defmodule Penny.RoomChannel do
  use Penny.Web, :channel

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
    # case Repo.all(Task) do
    #   nil ->
    #     push socket, "tasks", %{"tasks" => []}
    #     {:reply, {:ok, %{"tasks" => []}}, socket}
    #   {nil, _} ->
    #     push socket, "tasks", %{"tasks" => []}
    #     {:reply, {:ok, %{"tasks" => []}}, socket}
    #   tasks ->
    #     push socket, "tasks", %{"tasks" => tasks |> Enum.map(fn(%Task{name: name}) -> %{"name" => name} end) }
    #     {:reply, {:ok, %{"tasks" => tasks}}, socket}
    # end
    # tasks = Task |> Repo.all |> Enum.map(fn(task) -> Map.from_struct(task) end)
    # push socket, "mode", %{"tasks" => tasks}
    # {:ok, socket}
  end

  def handle_in("mode:get", _params, socket) do
    case Repo.one(from x in Event, order_by: [desc: x.id], limit: 1) do
      %Event{mode: mode} ->
        push socket, "mode", %{"mode" => mode}
        {:reply, {:ok, %{"mode" => mode}}, socket}
    end
  end

  def handle_in("mode:set", %{"mode" => mode}, socket) do
    changeset = Event.changeset(%Event{}, %{"mode" => mode, "event" => "set"})

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
end
