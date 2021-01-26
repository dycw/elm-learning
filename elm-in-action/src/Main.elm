module Main exposing (..)

import Browser exposing (Document)
import Html exposing (Html, a, caption, h1, li, nav, text, ul)
import Html.Attributes exposing (classList, href)
import Html.Events exposing (onMouseOver)
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
            ul
                []
                [ navLink Folders { url = "/", caption = "Folders" }
                , navLink Gallery { url = "/gallery", caption = "Gallery" }
                ]

        navLink : Page -> { url : String, caption : String } -> Html Msg
        navLink route { url, caption } =
            li
                [ classList [ ( "active", isActive { link = route, page = Debug.log "Rendering nav link with" page } ) ] ]
                [ a [ href url ] [ text caption ] ]
    in
    nav [ onMouseOver NothingYet ] [ logo, links ]


isActive : { link : Page, page : Page } -> Bool
isActive { link, page } =
    case ( link, page ) of
        ( Gallery, Gallery ) ->
            True

        ( Gallery, _ ) ->
            False

        ( Folders, Folders ) ->
            True

        -- ( Folders, SelectedPhoto _ ) ->
        --     True
        ( Folders, _ ) ->
            False

        ( NotFound, _ ) ->
            False


viewFooter : Html msg
viewFooter =
    text "Just a footer?"


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
