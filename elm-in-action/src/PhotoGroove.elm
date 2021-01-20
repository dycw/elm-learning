module PhotoGroove exposing (main)

import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (class, classList, id, src)
import Html.Events exposing (onClick)
import String exposing (String)


type alias Model =
    { photos : List Picture
    , selectedUrl : String
    }


type alias Picture =
    { url : String }


type alias Msg =
    { description : String, data : String }


initModel : Model
initModel =
    { photos =
        [ { url = "1.jpeg" }
        , { url = "2.jpeg" }
        , { url = "3.jpeg" }
        ]
    , selectedUrl = "1.jpeg"
    }


urlPrefix : String
urlPrefix =
    "http://elm-in-action.com/"


view : Model -> Html Msg
view { photos, selectedUrl } =
    div [ class "content" ]
        [ h1 [] [ text "Photo Groove" ]
        , div [ id "thumbnails" ]
            (List.map (viewThumbnail selectedUrl) photos)
        , img
            [ class "large", src (urlPrefix ++ "large/" ++ selectedUrl) ]
            []
        ]


viewThumbnail : String -> Picture -> Html Msg
viewThumbnail selectedUrl { url } =
    img
        [ src (urlPrefix ++ url)
        , classList [ ( "selected", selectedUrl == url ) ]
        , onClick { description = "ClickedPhoto", data = url }
        ]
        []


update : Msg -> Model -> Model
update { description, data } model =
    if description == "ClickedPhoto" then
        { model | selectedUrl = data }

    else
        model


main : Html Msg
main =
    view initModel
