-- START:module


port module ImageUpload exposing (main)

-- END:module
-- START:import.events
-- END:import.events
-- START:import.json.decode

import Browser
import Html exposing (Html, div, input, label, text)
import Html.Attributes exposing (class, for, id, multiple, type_)
import Html.Events exposing (on)
import Json.Decode exposing (succeed)



-- END:import.json.decode
-- START:onChange


onChange : msg -> Html.Attribute msg
onChange msg =
    on "change" (succeed msg)



-- END:onChange
-- START:port.uploadImages


port uploadImages : () -> Cmd msg



-- END:port.uploadImages


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

        -- START:input
        , input
            [ id "file-upload"
            , type_ "file"
            , multiple True
            , onChange UploadImages
            ]
            []

        -- END:input
        ]



-- START:msg


type Msg
    = UploadImages



-- END:msg


update : Msg -> Model -> ( Model, Cmd Msg )



-- START:update


update msg model =
    case msg of
        UploadImages ->
            ( model, uploadImages () )



-- END:update


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
