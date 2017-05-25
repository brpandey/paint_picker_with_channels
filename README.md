# PaintPickerWithChannels

![Logo](https://raw.githubusercontent.com/brpandey/paint_picker/master/priv/images/paintpicker.png)

### Description
Fun little web app that uses Elm and Phoenix to select paint cans (Phoenix db backend uses Postgres) 

Instead of requesting JSON from an API endpoint we use web socket channels via Phoenix Channels 
and also Elm ports to communicate with JS and the Phoenix channel

Now our paint can selects are stored within the DB using web socket channels


### Snippets

Phoenix channels code snippet

```elixir

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

```

JS code snippet

```javascript
                
        channel.join()
          .receive("ok", resp => { console.log("Joined successfully", resp) })
          .receive("error", resp => { console.log("Unable to join", resp) })

        // Receive phoenix channel event 'deliver_paints', notify Elm w/ a send!
        channel.on('deliver_paints', data => {
          console.log('received paints', data.paints)
          elmApp.ports.incomingPaints.send(data.paints)
        })


        // Subscribe to paint requests coming from Elm
        elmApp.ports.outgoingPaintRequests.subscribe(paint => {
          // push request to phoenix channel, handle error
          channel.push("request_paint", paint)
            .receive("error", payload => console.log(payload.message))
        })


        // Receive phoenix channel event 'paint_updated', notify Elm w/ a send!
        channel.on("paint_updated", paint => {
          console.log('paint_updated', paint)
          elmApp.ports.incomingPaintUpdates.send(paint)
        })

```


Elm snippet code

```haskell
        -- SUBSCRIPTIONS
        -- The incomingPaints port allows us to subscribe to lists of
        -- paint sent into Elm from JS on behalf of the Phoenix Channel
        -- The incomingPaintUpdates port allows us to subscribe to
        -- paint updates sent into Elm from JS on behalf of the Phoenix Channel
        -- NOTE: We use Sub.batch to handle both subscriptions properly


        port incomingPaints : (List Paint -> msg) -> Sub msg


        port incomingPaintUpdates : (Paint -> msg) -> Sub msg


        subscriptions : Model -> Sub Msg
        subscriptions model =
            Sub.batch
                    [ incomingPaints Incoming
                    , incomingPaintUpdates Pick
                    ]
```

Thanks Bibek