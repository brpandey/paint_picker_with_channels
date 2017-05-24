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
    = Pick Paint
    | Incoming Model


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Pick pickedPaint ->
            -- if we pick it once, its picked, twice, not picked
            let
                refreshPaint paint =
                    if paint.cart == pickedPaint.cart then
                        { paint | picked = not paint.picked }
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
        li [ class ("paint " ++ pickedClass), onClick (Pick paint) ]
            [ text (toString paint.cart ++ " " ++ paint.color) ]



-- SUBSCRIPTIONS
-- We create an incomingPaints port.
-- It is creating Sub (List Paint).
-- We are subscribing to lists of paint sent into Elm from JS.
-- When JS receives a deliver paint event from the phoenix channel,
-- it will send things on to Elm!
-- The port type is (List Paint -> msg) so we can convert that list of paint
-- to our Msg type immediately.
-- This allows us to send a list of paint from JS to Elm


port incomingPaints : (List Paint -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    incomingPaints Incoming
