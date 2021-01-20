module PhotoGroove exposing (main)

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
view { photos, selectedUrl } =
    div [ class "content" ]
        [ h1 [] [ text "Photo Groove" ]
        , div [ id "thumbnails" ]
            (List.map (viewThumbnail selectedUrl) photos)
        , img
            [ class "large", src (urlPrefix ++ "large/" ++ selectedUrl) ]
            []
        ]


viewThumbnail : String -> Picture -> Html msg
viewThumbnail selectedUrl { url } =
    let
        tail =
            if selectedUrl == url then
                [ class "selected" ]

            else
                []
    in
    img (src (urlPrefix ++ url) :: tail) []


main : Html Msg
main =
    view initModel
