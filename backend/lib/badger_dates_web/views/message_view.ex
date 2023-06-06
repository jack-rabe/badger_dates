defmodule BadgerDatesWeb.MessageView do
  use BadgerDatesWeb, :view
  alias BadgerDatesWeb.MessageView
  alias BadgerDates.Accounts.Message

  def render("index.json", %{messages: messages}) do
    %{data: render_many(messages, MessageView, "message.json")}
  end

  def render("show.json", %{message: message}) do
    %{data: render_one(message, MessageView, "message.json")}
  end

  def render("message.json", %{message: message = %Message{}}) do
    %{
      id: message.id,
      content: message.content,
      user: message.user_id,
      sent_at: message.inserted_at
    }
  end
end
