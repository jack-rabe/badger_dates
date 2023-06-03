defmodule BadgerDatesWeb.UserView do
  use BadgerDatesWeb, :view
  alias BadgerDatesWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      age: user.age,
      location: user.location,
      major: user.major,
      image_url: user.image_url
    }
  end
end
