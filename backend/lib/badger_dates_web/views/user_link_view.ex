defmodule BadgerDatesWeb.UserLinksView do
  use BadgerDatesWeb, :view

  alias BadgerDatesWeb.UserLinksView
  alias BadgerDates.Accounts.UserLink

  def render("index.json", %{links: links}) do
    %{data: render_many(links, UserLinksView, "link.json")}
  end

  # TODO fix this hacky way of passing users + link_id instead of links
  def render("with_users.json", %{links: users}) do
    %{data: render_many(users, UserLinksView, "with_users.json")}
  end

  def render("show.json", %{link: link}) do
    %{data: render_one(link, UserLinksView, "link.json")}
  end

  def render("link.json", %{user_links: link = %UserLink{}}) do
    %{
      user1: link.user1,
      user2: link.user2,
      user1_response: link.user1_response,
      user2_response: link.user2_response
    }
  end

  def render("with_users.json", %{user_links: user}) do
    %{
      id: user.id,
      link_id: user.link_id,
      name: user.name,
      major: user.major,
      location: user.location,
      age: user.age,
      image_url: user.image_url
    }
  end
end
