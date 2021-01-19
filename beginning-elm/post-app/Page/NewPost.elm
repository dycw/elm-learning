module Page.NewPost exposing (Model, Msg, init, view)

-- import Post exposing (Post, PostId, emptyPost, newPostEncoder, postDecoder)

import Browser.Navigation as Nav
import Error exposing (buildErrorMessage)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Post exposing (Post, PostId)
import Route



-- types


type alias Model =
    { navKey : Nav.Key }


type Msg
    = StoreTitle String
    | StoreAuthorName String
    | StoreAuthorUrl String



-- init


init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( initialModel navKey, Cmd.none )


initialModel : Nav.Key -> Model
initialModel navKey =
    { navKey = navKey }



-- model


view : Model -> Html Msg
view model =
    div [] [ h3 [] [ text "Create New Post" ], newPostForm ]


newPostForm : Html Msg
newPostForm =
    Html.form []
        [ div [] [ text "Title", br [] [], input [ type_ "text", onInput StoreTitle ] [] ]
        ]
