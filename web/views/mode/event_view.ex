defmodule Penny.Mode.EventView do
  use Penny.Web, :view

  # def render("index.json", %{mode_events: mode_events}) do
  #   %{data: render_many(mode_events, Penny.Mode.EventView, "event.json")}
  # end

  def render("show.json", %{event: event}) do
    render_one(event, Penny.Mode.EventView, "event.json")
  end

  def render("event.json", %{event: event}) do
    %{id: event.id,
      mode: event.mode,
      event: event.event,
      inserted_at: event.inserted_at}
  end
end
