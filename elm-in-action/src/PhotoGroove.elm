module PhotoGroove exposing (main)

import Array exposing (Array)
import Browser
import Html exposing (Html, button, div, h1, h3, img, input, label, text)
import Html.Attributes exposing (class, classList, id, name, src, type_)
import Html.Events exposing (onClick)
import Random


urlPrefix : String
urlPrefix =
    "http://elm-in-action.com/"


type Msg
    = ClickedPhoto String
    | GotSelectedIndex Int
    | ClickedSize ThumbnailSize
    | ClickedSurpriseMe


view : Model -> Html Msg
view { photos, selectedUrl, chosenSize } =
    div [ class "content" ]
        [ h1 [] [ text "Photo Groove" ]
        , button [ onClick ClickedSurpriseMe ] [ text "Surprise Me!" ]
        , h3 [] [ text "Thumbnail size:" ]
        , div [ id "choose-size" ] (List.map viewSizeChooser [ Small, Medium, Large ])
        , div [ id "thumbnails", class (sizeToString chosenSize) ]
            (List.map (viewThumbnail selectedUrl) photos)
        , img
            [ class "large", src (urlPrefix ++ "large/" ++ selectedUrl) ]
            []
        ]


viewThumbnail : String -> Photo -> Html Msg
viewThumbnail selectedUrl { url } =
    img
        [ src (urlPrefix ++ url)
        , classList [ ( "selected", selectedUrl == url ) ]
        , onClick (ClickedPhoto url)
        ]
        []


viewSizeChooser : ThumbnailSize -> Html Msg
viewSizeChooser size =
    label []
        [ input [ type_ "radio", name "size", onClick (ClickedSize size) ] []
        , text (sizeToString size)
        ]


sizeToString : ThumbnailSize -> String
sizeToString size =
    case size of
        Small ->
            "small"

        Medium ->
            "med"

        Large ->
            "large"


type ThumbnailSize
    = Small
    | Medium
    | Large


type alias Photo =
    { url : String }


type alias Model =
    { photos : List Photo
    , selectedUrl : String
    , chosenSize : ThumbnailSize
    }


initialModel : Model
initialModel =
    { photos =
        [ { url = "1.jpeg" }
        , { url = "2.jpeg" }
        , { url = "3.jpeg" }
        ]
    , selectedUrl = "1.jpeg"
    , chosenSize = Medium
    }


photoArray : Array Photo
photoArray =
    Array.fromList initialModel.photos


getPhotoUrl : Int -> String
getPhotoUrl index =
    case Array.get index photoArray of
        Just photo ->
            photo.url

        Nothing ->
            ""


randomPhotoPicker : Random.Generator Int
randomPhotoPicker =
    Random.int 0 (Array.length photoArray - 1)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedPhoto url ->
            ( { model | selectedUrl = url }, Cmd.none )

        ClickedSize size ->
            ( { model | chosenSize = size }, Cmd.none )

        ClickedSurpriseMe ->
            ( model, Random.generate GotSelectedIndex randomPhotoPicker )

        GotSelectedIndex index ->
            ( { model | selectedUrl = getPhotoUrl index }, Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }
