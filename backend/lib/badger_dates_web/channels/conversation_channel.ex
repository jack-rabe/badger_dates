defmodule BadgerDatesWeb.ConversationChannel do
  use BadgerDatesWeb, :channel

  # TODO - add authorization (needed across app)
  @impl true
  def join("conversation:lobby", _payload, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_in("message", payload, socket) do
    IO.inspect(payload)
    {:noreply, socket}
  end

  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end
end
