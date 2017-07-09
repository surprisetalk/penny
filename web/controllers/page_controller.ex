defmodule Penny.PageController do
  use Penny.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
