defmodule PaintPickerWithChannels.PaintChannel do
  use PaintPickerWithChannels.Web, :channel

  def join("paint:lobby", payload, socket) do
    if authorized?(payload) do
      send self(), :after_join # triggers the handle_info msg handler
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Triggered by the send self, after_join msg in join
  def handle_info(:after_join, socket) do
    paints = 
      (from p in PaintPickerWithChannels.Paint, order_by: [asc: p.cart]) 
      |> Repo.all

    push socket, "deliver_paints", %{paints: paints}
    {:noreply, socket}
  end


  # We handle the request_paint message (instead of previously locally within Elm)
  # payload holds the paint data we sent and socket carries the current socket state
  def handle_in("request_paint", payload, socket) do

    # Retrieve current paint record
    paint = Repo.get!(PaintPickerWithChannels.Paint, payload["cart"])

    # Invert the previous picked selection
    params = %{picked: !payload["picked"]} 

    # Update the record, validating the change
    changeset = PaintPickerWithChannels.Paint.changeset(paint, params)
    
    case Repo.update(changeset) do
      {:ok, paint} ->
        broadcast socket, "paint_updated", paint
        {:noreply, socket}
      {:error, _changeset} ->
        {:reply, {:error, %{message: "Didn't work!"}}, socket}
    end
  end


  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (paint:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
