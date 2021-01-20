module PhotoGroove exposing (main)

import Array exposing (Array)
import Browser
import Html exposing (Html, button, div, h1, img, text)
import Html.Attributes exposing (class, classList, id, src)
import Html.Events exposing (onClick)
import String exposing (String)


type alias Model =
    { photos : List Photo
    , selectedUrl : String
    , chosenSize : ThumbnailSize
    }


type alias Msg =
    { description : String
    , data : String
    }


type alias Photo =
    { url : String }


type ThumbnailSize
    = Small
    | Medium
    | Large


init : Model
init =
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
    Array.fromList init.photos


photoListUrl : String
photoListUrl =
    "http://elm-in-action.com/"


view : Model -> Html Msg
view { photos, selectedUrl } =
    div [ class "content" ]
        [ h1 [] [ text "Photo Groove" ]
        , button [ onClick { description = "ClickedSurpriseMe", data = "" } ] [ text "Surprise Me!" ]
        , div [ id "thumbnails" ]
            (List.map (viewThumbnail selectedUrl) photos)
        , img
            [ class "large", src (photoListUrl ++ "large/" ++ selectedUrl) ]
            []
        ]


viewThumbnail : String -> Photo -> Html Msg
viewThumbnail selectedUrl { url } =
    img
        [ src (photoListUrl ++ url)
        , classList [ ( "selected", selectedUrl == url ) ]
        , onClick { description = "ClickedPhoto", data = url }
        ]
        []


update : Msg -> Model -> Model
update { description, data } model =
    case description of
        "ClickedPhoto" ->
            { model | selectedUrl = data }

        "ClickedSurprisedMe" ->
            { model | selectedUrl = "2.jpeg" }

        _ ->
            model


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init, view = view, update = update }
