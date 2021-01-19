module CustomElements exposing (CropData)

import Asset
import Browser
import Html exposing (Attribute, Html, div, h2, strong, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (on)
import Json.Decode as Decode exposing (Decoder, int)
import Json.Decode.Pipeline exposing (requiredAt)


type alias CropData =
    { x : Int
    , y : Int
    , width : Int
    , height : Int
    }


type Msg
    = NoOp


imageCrop : List (Attribute a) -> List (Html a) -> Html a
imageCrop =
    Html.node "image-crop"


init : () -> ( CropData, Cmd Msg )
init flags =
    ( { x = 297, y = 0, width = 906, height = 906 }, Cmd.none )


view : CropData -> Html Msg
view cropData =
    div [ class "center" ]
        [ h2 [] [ text "Image Crop" ]
        , imageCrop
            [ Asset.src Asset.waterfall
            , class "wrapper"
            ]
            []
        ]


update : Msg -> CropData -> ( CropData, Cmd Msg )
update msg cropData =
    case msg of
        NoOp ->
            ( cropData, Cmd.none )


main : Program () CropData Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
