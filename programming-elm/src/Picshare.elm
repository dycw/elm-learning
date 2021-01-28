module Picshare exposing (main)

import Html exposing (Html, div, h1, h2, img, text)
import Html.Attributes exposing (class, src)


main : Html msg
main =
    div []
        [ div [ class "header" ] [ h1 [] [ text "Picshare" ] ]
        , div [ class "content-flow" ]
            [ viewDetailedPhoto (baseUrl ++ "1.jpg") "Surfing"
            , viewDetailedPhoto (baseUrl ++ "2.jpg") "The Fox"
            , viewDetailedPhoto (baseUrl ++ "3.jpg") "Evening"
            ]
        ]


viewDetailedPhoto : String -> String -> Html msg
viewDetailedPhoto url caption =
    div [ class "detailed-photo" ]
        [ img [ src url ] []
        , div [ class "photo-info" ] [ h2 [ class "caption" ] [ text caption ] ]
        ]


baseUrl : String
baseUrl =
    "https://programming-elm.com/"
