defmodule BadgerDatesWeb.MessageController do
  use BadgerDatesWeb, :controller

  alias BadgerDates.Accounts

  action_fallback BadgerDatesWeb.FallbackController

  # returns all messages associated w/ a single user_link
  def index(conn, %{"user_link" => user_link}) do
    messages = Accounts.list_messages(user_link)
    render(conn, "index.json", messages: messages)
  end
end
