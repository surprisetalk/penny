defmodule Penny.TaskController do
  use Penny.Web, :controller

  alias Penny.Task

  def index(conn, _params) do
    tasks = Task |> Repo.all
    render(conn, "index.json", tasks: tasks)
  end

  def create(conn, task_params) do
    changeset = Task.changeset(%Task{}, task_params)

    case Repo.insert(changeset) do
      {:ok, %Task{id: id}} ->
        task = Repo.one(Task,id)
        conn
        |> put_status(:created)
        |> put_resp_header("location", task_path(conn, :show, task))
        |> render("show.json", task: task)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Penny.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Repo.get!(Task, id)
    render(conn, "show.json", task: task)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Repo.get!(Task, id)
    changeset = Task.changeset(task, task_params)

    case Repo.update(changeset) do
      {:ok, task} ->
        render(conn, "show.json", task: task)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Penny.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Repo.get!(Task, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(task)

    send_resp(conn, :no_content, "")
  end
end
