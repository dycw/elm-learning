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
    div [ class "content" ]
        [ h1 [] [ text "Photo Groove" ]
        , div [ id "thumbnails" ]
            (List.map (\t -> viewThumbnail model.selectedUrl t) model.photos)
        , img
            [ class "large"
            , src (urlPrefix ++ "large/" ++ model.selectedUrl)
            ]
            []
        ]


viewThumbnail : String -> Picture -> Html msg
viewThumbnail selectedUrl thumb =
    let
        url =
            thumb.url

        attrs =
            src (urlPrefix ++ url)
                :: (if selectedUrl == url then
                        [ class "selected" ]

                    else
                        []
                   )
    in
    img attrs []



-- if selectedUrl == thumb.url then
--     img [ src (urlPrefix ++ thumb.url), class "selected" ] []
-- else
--     img [ src (urlPrefix ++ thumb.url) ] []
-- img [ src "http://elm-in-action.com/1.jpeg" ] []
-- , img [ src "http://elm-in-action.com/2.jpeg" ] []
-- , img [ src "http://elm-in-action.com/3.jpeg" ] []


main : Html Msg
main =
    view initModel
