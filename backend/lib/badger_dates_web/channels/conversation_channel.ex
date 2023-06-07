defmodule BadgerDatesWeb.ConversationChannel do
  use BadgerDatesWeb, :channel

  # TODO - add authorization (needed across app)
  @impl true
  def join("conversation:lobby", payload, socket) do
    IO.inspect(payload)
    {:ok, socket}
  end

  @impl true
  def handle_in(_, payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end
end
