port module PortExamples exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)



-- types


type alias Model =
    String


type Msg
    = SendDataToJS



-- init


init : () -> ( Model, Cmd Msg )
init _ =
    ( "", Cmd.none )



-- view


view : Model -> Html Msg
view _ =
    div []
        [ button [ onClick SendDataToJS ]
            [ text "Send Data to JavaScript" ]
        ]



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendDataToJS ->
            ( model, sendData "Hello JavaScript!" )


port sendData : String -> Cmd msg



-- main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
