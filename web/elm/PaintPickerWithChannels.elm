port module PaintPickerWithChannels exposing (..)

import Html exposing (Html, ul, li, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL
-- Paint is a record containing various attributes
-- assume these Paints work for interior and exterior and are the best brand
-- each paint record is 1 gallon


type alias Paint =
    { cart : Int
    , color : String
    , sheen : String
    , picked : Bool
    }



-- Model refers to List of Paints


type alias Model =
    List Paint


init : ( Model, Cmd msg )
init =
    ( [], Cmd.none )



-- UPDATE (let's add some interactivity so we can update our model!)


type Msg
    = Request Paint
    | Pick Paint
    | Incoming Model



-- Forward the outgoing paint requests to JS then the Websocket Channel


port outgoingPaintRequests : Paint -> Cmd msg


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Request paint ->
            ( model, outgoingPaintRequests paint )

        Pick pickedPaint ->
            let
                refreshPaint paint =
                    if paint.cart == pickedPaint.cart then
                        { paint | picked = pickedPaint.picked }
                    else
                        paint
            in
                -- apply to each model list paint
                ( List.map refreshPaint model, Cmd.none )

        Incoming paints ->
            ( paints, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    ul [ class "paints" ] (List.map paintSingle model)


paintSingle : Paint -> Html Msg
paintSingle paint =
    let
        pickedClass =
            if paint.picked then
                paint.color
            else
                "available"
    in
        li [ class ("paint " ++ pickedClass), onClick (Request paint) ]
            [ text (toString paint.cart ++ " " ++ paint.color) ]



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
