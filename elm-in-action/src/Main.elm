module Main exposing (..)

import Browser exposing (Document)
import Html exposing (Html, text)


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
        [ viewHeader model.page
        , content
        , viewFooter
        ]
    }


viewHeader : Page -> Html msg
viewHeader page =
    text "ok?"


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
