defmodule BadgerDatesWeb.UserLinksView do
  use BadgerDatesWeb, :view
  alias BadgerDatesWeb.UserLinksView
  alias BadgerDates.Accounts.UserLink

  def render("index.json", %{links: links}) do
    %{data: render_many(links, UserLinksView, "link.json")}
  end

  def render("show.json", %{link: link}) do
    %{data: render_one(link, UserLinksView, "link.json")}
  end

  def render("link.json", %{user_links: link = %UserLink{}}) do
    %{
      id: link.id,
      user1: link.user1,
      user2: link.user2,
      user1_response: link.user1_response,
      user2_response: link.user2_response
    }
  end
end
