defmodule Penny.Router do
  use Penny.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Penny do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", Penny do
    pipe_through :api

    resources "/tasks", TaskController, except: [:new, :edit]
    resources "/mode", Mode.EventController, only: [:index, :create]
  end
end
