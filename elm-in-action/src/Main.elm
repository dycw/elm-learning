module Main exposing (..)

import Browser exposing (Document)
import Html exposing (Html, a, caption, h1, li, nav, text, ul)
import Html.Attributes exposing (classList, href)
import Html.Lazy exposing (lazy)


type alias Model =
    { page : Page }


type Page
    = Gallery
    | Folders
    | NotFound


init : () -> ( Model, Cmd Msg )
init _ =
    ( { page = Gallery }, Cmd.none )


view : Model -> Document Msg
view model =
    let
        content =
            text "This isn't even my final form!"
    in
    { title = "Photo Groove, SPA Style"
    , body =
        [ lazy viewHeader model.page
        , content
        , viewFooter
        ]
    }


viewHeader : Page -> Html Msg
viewHeader page =
    let
        logo : Html Msg
        logo =
            h1 [] [ text "Photo Groove" ]

        links : Html Msg
        links =
            ul []
                [ navLink Folders { url = "/", caption = "Folders" }
                , navLink Gallery { url = "/gallery", caption = "Gallery" }
                ]

        navLink : Page -> { url : String, caption : String } -> Html Msg
        navLink targetPage { url, caption } =
            li [ classList [ ( "active", page == targetPage ) ] ] [ a [ href url ] [ text caption ] ]
    in
    nav [] [ logo, links ]


viewFooter : Html msg
viewFooter =
    text "ok?"


type Msg
    = NothingYet


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
