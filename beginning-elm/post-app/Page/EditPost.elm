module Page.EditPost exposing (Model, Msg, init, update, view)

import Browser.Navigation as Nav
import Css.Global exposing (html)
import Error exposing (buildErrorMessage)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Post exposing (Post, PostId, postDecoder, postEncoder)
import RemoteData exposing (WebData)
import Route


type alias Model =
    { navKey : Nav.Key
    , post : WebData Post
    , saveError : Maybe String
    }


type Msg
    = PostReceived (WebData Post)
    | UpdateTitle String
    | UpdateAuthorName String
    | UpdateAuthorUrl String
    | SavePost
    | PostSaved (Result Http.Error Post)



-- init


init : PostId -> Nav.Key -> ( Model, Cmd Msg )
init postId navKey =
    ( initialModel navKey, fetchPost postId )


initialModel : Nav.Key -> Model
initialModel navKey =
    { navKey = navKey
    , post = RemoteData.Loading
    , saveError = Nothing
    }


fetchPost : PostId -> Cmd Msg
fetchPost postId =
    Http.get
        { url = "http://localhost:5019/posts/" ++ Post.idToString postId
        , expect =
            postDecoder
                |> Http.expectJson (RemoteData.fromResult >> PostReceived)
        }



-- view


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Edit Post" ]
        , viewPost model.post
        , viewSaveError model.saveError
        ]


viewPost : WebData Post -> Html Msg
viewPost post =
    case post of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            h3 [] [ text "Loading Post..." ]

        RemoteData.Success postData ->
            editForm postData

        RemoteData.Failure httpError ->
            viewFetchError (buildErrorMessage httpError)


editForm : Post -> Html Msg
editForm post =
    Html.form []
        [ div []
            [ text "Title"
            , br [] []
            , input
                [ type_ "text"
                , value post.title
                , onInput UpdateTitle
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Author Name"
            , br [] []
            , input
                [ type_ "text"
                , value post.authorName
                , onInput UpdateAuthorName
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Author URL"
            , br [] []
            , input
                [ type_ "text"
                , value post.authorUrl
                , onInput UpdateAuthorUrl
                ]
                []
            ]
        , br [] []
        , div []
            [ button [ type_ "button", onClick SavePost ]
                [ text "Submit" ]
            ]
        ]


viewFetchError : String -> Html Msg
viewFetchError string =
    div []
        [ h3 [] [ text "Couldn't fetch post at this time." ]
        , text ("Error: " ++ string)
        ]


viewSaveError : Maybe String -> Html msg
viewSaveError maybeString =
    case maybeString of
        Just string ->
            div []
                [ h3 [] [ text "Couldn't save post at this time." ]
                , text ("Error: " ++ string)
                ]

        Nothing ->
            text ""



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PostReceived post ->
            ( { model | post = post }, Cmd.none )

        UpdateTitle newTitle ->
            ( { model | post = RemoteData.map (\postData -> { postData | title = newTitle }) model.post }, Cmd.none )

        UpdateAuthorName newName ->
            ( { model | post = RemoteData.map (\postData -> { postData | authorName = newName }) model.post }, Cmd.none )

        UpdateAuthorUrl newUrl ->
            ( { model | post = RemoteData.map (\postData -> { postData | authorUrl = newUrl }) model.post }, Cmd.none )

        SavePost ->
            ( model, savePost model.post )

        PostSaved (Ok postData) ->
            ( { model
                | post = RemoteData.succeed postData
                , saveError = Nothing
              }
            , Route.pushUrl Route.Posts model.navKey
            )

        PostSaved (Err error) ->
            ( { model | saveError = Just (buildErrorMessage error) }, Cmd.none )


savePost : WebData Post -> Cmd Msg
savePost post =
    case post of
        RemoteData.Success postData ->
            Http.request
                { method = "PATCH"
                , headers = []
                , url = "http://localhost:5019/posts/" ++ Post.idToString postData.id
                , body = Http.jsonBody (postEncoder postData)
                , expect = Http.expectJson PostSaved postDecoder
                , timeout = Nothing
                , tracker = Nothing
                }

        _ ->
            Cmd.none
