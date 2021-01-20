module EventListener exposing (Model)

import Browser
import Browser.Events exposing (onClick, onKeyPress)
import Css exposing (Ch)
import Html exposing (..)
import Json.Decode as Decode


type alias Model =
    Int


type Msg
    = CharacterKey Char
    | ControlKey String
    | MouseClick


init : () -> ( Model, Cmd Msg )
init _ =
    ( 0, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ text (String.fromInt model) ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CharacterKey 'i' ->
            ( model + 1, Cmd.none )

        CharacterKey 'd' ->
            ( model - 1, Cmd.none )

        CharacterKey _ ->
            ( model, Cmd.none )

        ControlKey _ ->
            ( model, Cmd.none )

        MouseClick ->
            ( model + 5, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ onKeyPress keyDecoder
        , onClick (Decode.succeed MouseClick)
        ]


keyDecoder : Decode.Decoder Msg
keyDecoder =
    Decode.map toKey (Decode.field "key" Decode.string)


toKey : String -> Msg
toKey keyValue =
    case String.uncons keyValue of
        Just ( char, "" ) ->
            CharacterKey char

        _ ->
            ControlKey keyValue


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
