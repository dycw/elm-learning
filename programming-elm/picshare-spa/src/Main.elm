module Main exposing (main)

import Account
import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Navigation
import Html exposing (Html, a, div, h1, i, text)
import Html.Attributes exposing (class)
import PublicFeed
import Routes exposing (Route(..))
import Url exposing (Url)
import UserFeed
import WebSocket



---- MODEL ----


type Page
    = PublicFeed PublicFeed.Model
    | UserFeed String UserFeed.Model
    | Account Account.Model
    | NotFound


type alias Model =
    { page : Page, navigationKey : Navigation.Key }


initialModel : Navigation.Key -> Model
initialModel navigationKey =
    { page = NotFound, navigationKey = navigationKey }


init : () -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init () url navigationKey =
    setNewPage (Routes.match url) (initialModel navigationKey)



---- VIEW ----


view : Model -> Document Msg
view model =
    let
        ( title, content ) =
            viewContent model.page
    in
    { title = title
    , body = [ viewHeader, content ]
    }


viewContent : Page -> ( String, Html Msg )
viewContent page =
    case page of
        PublicFeed publicFeedModel ->
            ( "Picshare"
            , PublicFeed.view publicFeedModel |> Html.map PublicFeedMsg
            )

        UserFeed username userFeedModel ->
            ( "User Feed for @" ++ username
            , UserFeed.view userFeedModel |> Html.map UserFeedMsg
            )

        Account accountModel ->
            ( "Account"
            , Account.view accountModel |> Html.map AccountMsg
            )

        NotFound ->
            ( "Not Found"
            , div [ class "not-found" ] [ h1 [] [ text "Page Not Found" ] ]
            )


viewHeader : Html Msg
viewHeader =
    div [ class "header" ]
        [ div [ class "header-nav" ]
            [ a
                [ class "nav-brand"
                , Routes.href Routes.Home
                ]
                [ text "Picshare" ]
            , a
                [ class "nav-accound"
                , Routes.href Routes.Account
                ]
                [ i [ class "fa fa-2x fa-gear" ] [] ]
            ]
        ]



---- UPDATE ----


type Msg
    = NewRoute (Maybe Routes.Route)
    | Visit UrlRequest
    | AccountMsg Account.Msg
    | PublicFeedMsg PublicFeed.Msg
    | UserFeedMsg UserFeed.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( NewRoute maybeRoute, _ ) ->
            let
                ( updatedModel, cmd ) =
                    setNewPage maybeRoute model
            in
            ( updatedModel
            , Cmd.batch [ cmd, WebSocket.close () ]
            )

        ( AccountMsg accountMsg, Account accountModel ) ->
            let
                ( updatedAccountModel, accountCmd ) =
                    Account.update accountMsg accountModel
            in
            ( { model | page = Account updatedAccountModel }
            , Cmd.map AccountMsg accountCmd
            )

        ( PublicFeedMsg publicFeedMsg, PublicFeed publicFeedModel ) ->
            let
                ( updatedPublicFeedModel, publicFeedCmd ) =
                    PublicFeed.update publicFeedMsg publicFeedModel
            in
            ( { model | page = PublicFeed updatedPublicFeedModel }
            , Cmd.map PublicFeedMsg publicFeedCmd
            )

        ( Visit (Browser.Internal url), _ ) ->
            ( model, Navigation.pushUrl model.navigationKey (Url.toString url) )

        _ ->
            ( model, Cmd.none )


setNewPage : Maybe Routes.Route -> Model -> ( Model, Cmd Msg )
setNewPage maybeRoute model =
    case maybeRoute of
        Just Routes.Home ->
            let
                ( publicFeedModel, publicFeedCmd ) =
                    PublicFeed.init
            in
            ( { model | page = PublicFeed publicFeedModel }
            , Cmd.map PublicFeedMsg publicFeedCmd
            )

        Just (Routes.UserFeed username) ->
            let
                ( userFeedModel, userFeedCmd ) =
                    UserFeed.init username
            in
            ( { model | page = UserFeed username userFeedModel }
            , Cmd.map UserFeedMsg userFeedCmd
            )

        Just Routes.Account ->
            let
                ( accountModel, accountCmd ) =
                    Account.init
            in
            ( { model | page = Account accountModel }
            , Cmd.map AccountMsg accountCmd
            )

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        PublicFeed publicFeedModel ->
            PublicFeed.subscriptions publicFeedModel |> Sub.map PublicFeedMsg

        _ ->
            Sub.none



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = Visit
        , onUrlChange = Routes.match >> NewRoute
        }
