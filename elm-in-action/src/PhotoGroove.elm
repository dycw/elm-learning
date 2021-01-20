module PhotoGroove exposing (main)

import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (class, id, src)


type alias Model =
    List { url : String }


type Msg
    = NoOp


initModel : Model
initModel =
    [ { url = "1.jpeg" }
    , { url = "2.jpeg" }
    , { url = "3.jpeg" }
    ]


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ h1 [] [ text "Photo Groove" ]
        , div [ id "thumbnails" ]
            [ img [ src "http://elm-in-action.com/1.jpeg" ] []
            , img [ src "http://elm-in-action.com/2.jpeg" ] []
            , img [ src "http://elm-in-action.com/3.jpeg" ] []
            ]
        ]


main : Html Msg
main =
    view initModel
