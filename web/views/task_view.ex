defmodule Penny.TaskView do
  use Penny.Web, :view

  def render("index.json", %{tasks: tasks}) do
    render_many(tasks, Penny.TaskView, "task.json")
  end

  def render("show.json", %{task: task}) do
    render_one(task, Penny.TaskView, "task.json")
  end

  def render("task.json", %{task: task}) do
    %{id: task.id,
      name: task.name,
      body: task.body,
      kind: task.kind,
      urgent: task.urgent,
      important: task.important,
      task_id: task.task_id
      # status: task.status,
      # tasks: render("index.json", %{tasks: task.tasks})}
      }
  end
end
