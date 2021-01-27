module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav exposing (Key)
import Html exposing (Html, a, caption, h1, hr, li, nav, text, ul)
import Html.Attributes exposing (classList, href)
import Html.Events exposing (onMouseOver)
import Html.Lazy exposing (lazy)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, s, string)


type alias Model =
    { page : Page, key : Nav.Key }


type Page
    = SelectedPhoto String
    | Gallery
    | Folders
    | NotFound


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { page = urlToPage url, key = key }, Cmd.none )


urlToPage : Url -> Page
urlToPage url =
    Parser.parse parser url |> Maybe.withDefault NotFound


parser : Parser (Page -> a) a
parser =
    Parser.oneOf
        [ Parser.map Folders Parser.top
        , Parser.map Gallery (s "gallery")
        , Parser.map SelectedPhoto (s "photo" </> Parser.string)
        ]


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
    nav [] [ logo, links ]


isActive : { link : Page, page : Page } -> Bool
isActive { link, page } =
    case ( link, page ) of
        ( Gallery, Gallery ) ->
            True

        ( Gallery, _ ) ->
            False

        ( Folders, Folders ) ->
            True

        ( Folders, SelectedPhoto _ ) ->
            True

        ( Folders, _ ) ->
            False

        ( SelectedPhoto _, _ ) ->
            False

        ( NotFound, _ ) ->
            False


viewFooter : Html msg
viewFooter =
    text "Just a footer?"


type Msg
    = ClickedLink UrlRequest
    | ChangedUrl Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedLink urlRequest ->
            case urlRequest of
                Browser.External href ->
                    ( model, Nav.load href )

                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

        ChangedUrl url ->
            ( { model | page = urlToPage url }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


onUrlRequest : UrlRequest -> Msg
onUrlRequest _ =
    Debug.todo "handle URL requests"


onUrlChange : Url -> Msg
onUrlChange _ =
    Debug.todo "handle URL changes"


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangedUrl
        }
