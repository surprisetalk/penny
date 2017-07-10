defmodule Penny.TaskTest do
  use Penny.ModelCase

  alias Penny.Task

  @valid_attrs %{body: "some content", important: true, kind: "some content", name: "some content", urgent: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Task.changeset(%Task{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Task.changeset(%Task{}, @invalid_attrs)
    refute changeset.valid?
  end
end
