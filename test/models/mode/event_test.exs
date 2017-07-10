defmodule Penny.Mode.EventTest do
  use Penny.ModelCase

  alias Penny.Mode.Event

  @valid_attrs %{event: "some content", mode: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Event.changeset(%Event{}, @invalid_attrs)
    refute changeset.valid?
  end
end
