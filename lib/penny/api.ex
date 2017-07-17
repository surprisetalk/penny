defmodule Penny.Api do
  use Plug.Router
  require Logger

  plug Plug.Logger
  plug :match
  plug :dispatch

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Poison

  def init(options) do
    options
  end

  def start_link do
    {:ok, _} = Plug.Adapters.Cowboy.http __MODULE__, []
  end

  get "/mode" do
    mode = :mongo
    |> Mongo.find("modes", %{}, sort: %{"$natural" => -1}, limit: 1)
    |> Enum.to_list
    |> List.first
    |> Map.update("_id", nil, &BSON.ObjectId.encode!/1)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(mode))
    |> halt
  end

  post "/mode/:event/:mode" do
    mode = conn.params
    |> Map.update("mode", "NAUGHT", &String.upcase/1)
    |> Map.update("event", "AUTO", &String.upcase/1)
    |> Map.put("ts", DateTime.utc_now())

    Mongo.insert_one!(:mongo, "modes", mode)

    conn
    |> send_resp(201, "")
    |> halt
  end

  get "/tasks" do
    :mongo
    |> Mongo.find("tasks", %{})
    |> Enum.to_list
    |> inspect
    |> IO.puts

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{name: "tay"}))
    |> halt
  end

  match _ do
    conn
    |> send_resp(404, "not found")
    |> halt
  end

end
