module Picshare exposing (main)

import Html exposing (Html, div, h1, h2, img, text)
import Html.Attributes exposing (class, src)


main : Html msg
main =
    view initialModel


viewDetailedPhoto : { url : String, caption : String } -> Html msg
viewDetailedPhoto { url, caption } =
    div [ class "detailed-photo" ]
        [ img [ src url ] []
        , div [ class "photo-info" ] [ h2 [ class "caption" ] [ text caption ] ]
        ]


baseUrl : String
baseUrl =
    "https://programming-elm.com/"


initialModel : { url : String, caption : String }
initialModel =
    { url = baseUrl ++ "1.jpg"
    , caption = "Surfing"
    }


view : { url : String, caption : String } -> Html msg
view model =
    div []
        [ div [ class "header" ] [ h1 [] [ text "Picshare" ] ]
        , div [ class "content-flow" ] [ viewDetailedPhoto model ]
        ]
