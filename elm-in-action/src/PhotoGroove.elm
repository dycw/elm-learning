module PhotoGroove exposing (main)

import Array
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (class, id, src)
import String exposing (String)


type alias Model =
    List Thumbnail


type alias Thumbnail =
    { url : String }


type Msg
    = NoOp


initModel : Model
initModel =
    [ { url = "1.jpeg" }
    , { url = "2.jpeg" }
    , { url = "3.jpeg" }
    ]


urlPrefix : String
urlPrefix =
    "http://elm-in-action.com/"


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ h1 [] [ text "Photo Groove" ]
        , div [ id "thumbnails" ]
            (List.map viewThumbnail initModel)
        ]


viewThumbnail : Thumbnail -> Html msg
viewThumbnail thumb =
    img [ src (urlPrefix ++ thumb.url) ] []



-- img [ src "http://elm-in-action.com/1.jpeg" ] []
-- , img [ src "http://elm-in-action.com/2.jpeg" ] []
-- , img [ src "http://elm-in-action.com/3.jpeg" ] []


main : Html Msg
main =
    view initModel
