module Main exposing (main)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Html exposing (..)
import Http
import Json.Decode as Decode exposing (Value, decodeString, decodeValue)
import Page.EditPost as EditPost
import Page.ListPosts as ListPosts
import Page.NewPost as NewPost
import Post exposing (Post, postsDecoder)
import RemoteData exposing (WebData)
import Route exposing (Route)
import Url exposing (Url)


type alias Model =
    { route : Route
    , page : Page
    , navKey : Nav.Key
    }


type Msg
    = ListPageMsg ListPosts.Msg
    | LinkClicked UrlRequest
    | UrlChanged Url
    | EditPageMsg EditPost.Msg
    | NewPageMsg NewPost.Msg


type Page
    = NotFoundPage
    | ListPage ListPosts.Model
    | EditPage EditPost.Model
    | NewPage NewPost.Model



-- init


init : Value -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        model =
            { route = Route.parseUrl url
            , page = NotFoundPage
            , navKey = navKey
            }

        posts =
            case decodeValue Decode.string flags of
                Ok postsJson ->
                    decodeStoredPosts postsJson

                Err _ ->
                    Http.BadBody "Flags must be either string or null" |> RemoteData.Failure
    in
    initCurrentPage posts ( model, Cmd.none )


decodeStoredPosts : String -> WebData (List Post)
decodeStoredPosts postsJson =
    case decodeString postsDecoder postsJson of
        Ok posts ->
            RemoteData.succeed posts

        Err _ ->
            RemoteData.Loading


initCurrentPage : WebData (List Post) -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage posts ( model, existingCmds ) =
    let
        ( currentPage, mappedPageCmds ) =
            case model.route of
                Route.NotFound ->
                    ( NotFoundPage, Cmd.none )

                Route.Posts ->
                    let
                        ( pageModel, pageCmds ) =
                            ListPosts.init posts
                    in
                    ( ListPage pageModel, Cmd.map ListPageMsg pageCmds )

                Route.Post postId ->
                    let
                        ( pageModel, pageCmd ) =
                            EditPost.init postId model.navKey
                    in
                    ( EditPage pageModel, Cmd.map EditPageMsg pageCmd )

                Route.NewPost ->
                    let
                        ( pageModel, pageCmd ) =
                            NewPost.init model.navKey
                    in
                    ( NewPage pageModel, Cmd.map NewPageMsg pageCmd )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )



-- view


view : Model -> Document Msg
view model =
    { title = "Post App"
    , body = [ currentView model ]
    }


currentView : Model -> Html Msg
currentView model =
    case model.page of
        NotFoundPage ->
            notFoundView

        ListPage pageModel ->
            ListPosts.view pageModel |> Html.map ListPageMsg

        EditPage pageModel ->
            EditPost.view pageModel |> Html.map EditPageMsg

        NewPage pageModel ->
            NewPost.view pageModel |> Html.map NewPageMsg


notFoundView : Html msg
notFoundView =
    h3 [] [ text "Oops! The page you requested was not found!" ]



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( ListPageMsg subMsg, ListPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ListPosts.update subMsg pageModel
            in
            ( { model | page = ListPage updatedPageModel }
            , Cmd.map ListPageMsg updatedCmd
            )

        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.navKey (Url.toString url) )

                Browser.External url ->
                    ( model, Nav.load url )

        ( UrlChanged url, _ ) ->
            ( { model | route = Route.parseUrl url }, Cmd.none )
                |> initCurrentPage RemoteData.Loading

        ( EditPageMsg subMsg, EditPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    EditPost.update subMsg pageModel
            in
            ( { model | page = EditPage updatedPageModel }
            , Cmd.map EditPageMsg updatedCmd
            )

        ( NewPageMsg subMsg, NewPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    NewPost.update subMsg pageModel
            in
            ( { model | page = NewPage updatedPageModel }
            , Cmd.map NewPageMsg updatedCmd
            )

        ( _, _ ) ->
            ( model, Cmd.none )



-- main


main : Program Value Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
