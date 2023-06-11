defmodule BadgerDatesWeb.ConversationChannel do
  use BadgerDatesWeb, :channel

  # TODO - add authorization (needed across app)
  @impl true
  def join("conversation:" <> _link_id, _payload, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_in("create_message", msg, socket) do
    case BadgerDates.Accounts.create_message(msg) do
      {:ok, %{id: id, content: content, user_id: user_id, inserted_at: sent_at}} ->
        broadcast(socket, "message_sent", %{
          id: id,
          content: content,
          user: user_id,
          sent_at: sent_at
        })

        {:noreply, socket}

      _err ->
        IO.puts("error creating message")
        {:noreply, socket}
    end
  end

  def handle_in("message_sent", payload, socket) do
    IO.inspect(payload)
    {:noreply, socket}
  end

  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end
end
