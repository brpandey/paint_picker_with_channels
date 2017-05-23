module PaintPickerWithChannels exposing (..)

import Html exposing (Html, ul, li, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , update = update
        , view = view
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


init : Model
init =
    [ { cart = 1, color = "salmon", sheen = "gloss", picked = False }
    , { cart = 2, color = "tomato", sheen = "flat", picked = False }
    , { cart = 3, color = "darkorange", sheen = "satin", picked = False }
    , { cart = 4, color = "indianred", sheen = "gloss", picked = False }
    , { cart = 5, color = "greenyellow", sheen = "eggshell", picked = False }
    , { cart = 6, color = "mediumspringgreen", sheen = "eggshell", picked = False }
    , { cart = 7, color = "khaki", sheen = "flat", picked = False }
    , { cart = 8, color = "gold", sheen = "flat", picked = False }
    , { cart = 9, color = "teal", sheen = "semi-gloss", picked = False }
    , { cart = 10, color = "maroon", sheen = "semi-gloss", picked = False }
    ]



-- UPDATE (let's add some interactivity so we can update our model!)


type Msg
    = Pick Paint


update : Msg -> Model -> Model
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
                List.map refreshPaint model



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
