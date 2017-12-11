defmodule DealiefWeb.Api.V1.UserView do
  use DealiefWeb, :view
  alias DealiefWeb.Api.V1.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user, token: token}) do
    %{data:
      %{id: user.id,
      full_name: user.full_name,
      email: user.email,
      token: token}}
  end  

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      full_name: user.full_name,
      email: user.email}
  end
end
