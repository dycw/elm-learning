port module PortExamples exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)



-- types


type alias Model =
    String


type Msg
    = SendDataToJS
    | ReceivedDataFromJS Model



-- init


init : () -> ( Model, Cmd Msg )
init _ =
    ( "", Cmd.none )



-- view


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick SendDataToJS ]
            [ text "Send Data to JavaScript" ]
        , br [] []
        , br [] []
        , text ("Data received from Javascript: " ++ model)
        ]



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendDataToJS ->
            ( model, sendData "Hello JavaScript!" )

        ReceivedDataFromJS data ->
            ( data, Cmd.none )


port sendData : String -> Cmd msg


port receiveData : (Model -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions _ =
    receiveData ReceivedDataFromJS



-- main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
