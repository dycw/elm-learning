module PhotoGroove exposing (main)

import Array
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (class, id, src)
import String exposing (String)


type alias Model =
    { photos : List Picture
    , selectedUrl : String
    }


type alias Picture =
    { url : String }


type Msg
    = NoOp


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
view model =
    let
        url =
            model.selectedUrl
    in
    div [ class "content" ]
        [ h1 [] [ text "Photo Groove" ]
        , div [ id "thumbnails" ]
            (List.map (viewThumbnail url) model.photos)
        , img
            [ class "large", src (urlPrefix ++ "large/" ++ url) ]
            []
        ]


viewThumbnail : String -> Picture -> Html msg
viewThumbnail selectedUrl thumb =
    let
        url =
            thumb.url

        head =
            urlPrefix ++ url

        tail =
            if selectedUrl == url then
                [ class "selected" ]

            else
                []
    in
    img (src head :: tail) []


main : Html Msg
main =
    view initModel
