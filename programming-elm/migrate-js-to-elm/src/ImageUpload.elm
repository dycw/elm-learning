module ImageUpload exposing (main)

import Browser
import Html exposing (Html, div, input, label, text)
import Html.Attributes exposing (class, for, id, multiple, type_)


type alias Model =
    ()


init : () -> ( Model, Cmd Msg )
init () =
    ( (), Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "image-upload" ]
        [ label [ for "file-upload" ]
            [ text "+ Add Images" ]
        , input
            [ id "file-upload"
            , type_ "file"
            , multiple True
            ]
            []
        ]


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
