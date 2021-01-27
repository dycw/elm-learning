module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav exposing (Key)
import Html exposing (Html, a, caption, h1, hr, li, nav, text, ul)
import Html.Attributes exposing (classList, href)
import Html.Events exposing (onMouseOver)
import Html.Lazy exposing (lazy)
import PhotoFolders as Folders
import PhotoGallery as Gallery
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, s, string)


type alias Model =
    { page : Page, key : Nav.Key, version : Float }


type Page
    = GalleryPage Gallery.Model
    | FoldersPage Folders.Model
    | NotFound


type Route
    = Gallery
    | Folders
    | SelectedPhoto String


init : Float -> Url -> Nav.Key -> ( Model, Cmd Msg )
init version url key =
    ( { page = urlToPage version url
      , key = key
      , version = version
      }
    , Cmd.none
    )


urlToPage : Float -> Url -> Page
urlToPage version url =
    case Parser.parse parser url of
        Just Gallery ->
            GalleryPage (Tuple.first (Gallery.init version))

        Just Folders ->
            FoldersPage (Tuple.first (Folders.init Nothing))

        Just (SelectedPhoto filename) ->
            FoldersPage (Tuple.first (Folders.init (Just filename)))

        Nothing ->
            NotFound


parser : Parser (Route -> a) a
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
            case model.page of
                FoldersPage folders ->
                    Folders.view folders |> Html.map GotFoldersMsg

                GalleryPage gallery ->
                    Gallery.view gallery |> Html.map GotGalleryMsg

                NotFound ->
                    text "Not found"
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

        navLink : Route -> { url : String, caption : String } -> Html msg
        navLink route { url, caption } =
            li
                [ classList [ ( "active", isActive { link = route, page = Debug.log "Rendering nav link with" page } ) ] ]
                [ a [ href url ] [ text caption ] ]
    in
    nav [] [ logo, links ]


isActive : { link : Route, page : Page } -> Bool
isActive { link, page } =
    case ( link, page ) of
        ( Gallery, GalleryPage _ ) ->
            True

        ( Gallery, _ ) ->
            False

        ( Folders, FoldersPage _ ) ->
            True

        ( Folders, _ ) ->
            False

        ( SelectedPhoto _, _ ) ->
            False


viewFooter : Html msg
viewFooter =
    text "Just a footer?"


type Msg
    = ClickedLink UrlRequest
    | ChangedUrl Url
    | GotFoldersMsg Folders.Msg
    | GotGalleryMsg Gallery.Msg


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
            ( { model | page = urlToPage model.version url }
            , Cmd.none
            )

        GotFoldersMsg foldersMsg ->
            case model.page of
                FoldersPage folders ->
                    toFolders model (Folders.update foldersMsg folders)

                _ ->
                    ( model, Cmd.none )

        GotGalleryMsg galleryMsg ->
            case model.page of
                GalleryPage gallery ->
                    toGallery model (Gallery.update galleryMsg gallery)

                _ ->
                    ( model, Cmd.none )


toFolders : Model -> ( Folders.Model, Cmd Folders.Msg ) -> ( Model, Cmd Msg )
toFolders model ( folders, cmd ) =
    ( { model | page = FoldersPage folders }
    , Cmd.map GotFoldersMsg cmd
    )


toGallery : Model -> ( Gallery.Model, Cmd Gallery.Msg ) -> ( Model, Cmd Msg )
toGallery model ( gallerys, cmd ) =
    ( { model | page = GalleryPage gallerys }
    , Cmd.map GotGalleryMsg cmd
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        GalleryPage gallery ->
            Gallery.subscriptions gallery |> Sub.map GotGalleryMsg

        _ ->
            Sub.none


onUrlRequest : UrlRequest -> Msg
onUrlRequest _ =
    Debug.todo "handle URL requests"


onUrlChange : Url -> Msg
onUrlChange _ =
    Debug.todo "handle URL changes"


main : Program Float Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangedUrl
        }
