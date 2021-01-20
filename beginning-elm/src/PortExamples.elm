port module PortExamples exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Json.Decode exposing (Error(..), Value, decodeValue, string)



-- types


type alias ComplexData =
    { posts : List Post
    , comments : List Comment
    , profile : Profile
    }


type alias Post =
    { id : Int
    , title : String
    , author : Author
    }


type alias Author =
    { name : String
    , url : String
    }


type alias Comment =
    { id : Int
    , body : String
    , postId : Int
    }


type alias Profile =
    { name : String }


type alias Model =
    { dataFromJS : String
    , dataToJS : ComplexData
    , jsonError : Maybe Error
    }


type Msg
    = SendDataToJS
    | ReceivedDataFromJS Value



-- init


init : () -> ( Model, Cmd Msg )
init _ =
    ( { dataFromJS = ""
      , dataToJS = complexData
      , jsonError = Nothing
      }
    , Cmd.none
    )


complexData : ComplexData
complexData =
    { posts =
        [ Author "typicode" "https://github.com/typicode"
            |> Post 1 "json-server"
        , Author "indexzero" "https://github.com/indexzero"
            |> Post 2 "http-server"
        ]
    , comments = [ Comment 1 "some comment" 1 ]
    , profile = { name = "typicode" }
    }



-- view


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick SendDataToJS ]
            [ text "Send Data to JavaScript" ]
        , viewDataFromJSOrError model
        ]


viewDataFromJSOrError : Model -> Html Msg
viewDataFromJSOrError model =
    case model.jsonError of
        Just error ->
            viewError error

        Nothing ->
            viewDataFromJS model.dataFromJS


viewError : Error -> Html Msg
viewError error =
    let
        errorMessage =
            case error of
                Failure message _ ->
                    message

                _ ->
                    "Error: Invalid JSON"
    in
    div []
        [ h3 [] [ text "Couldn't retrieve data from JavaScript" ]
        , text ("Error: " ++ errorMessage)
        ]


viewDataFromJS : String -> Html msg
viewDataFromJS data =
    div []
        [ br [] []
        , br [] []
        , text "Data received from Javascript: "
        , text data
        ]



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendDataToJS ->
            ( model, sendData model.dataToJS )

        ReceivedDataFromJS value ->
            case decodeValue string value of
                Ok data ->
                    ( { model | dataFromJS = data }, Cmd.none )

                Err error ->
                    ( { model | jsonError = Just error }, Cmd.none )


port sendData : ComplexData -> Cmd msg


port receiveData : (Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions _ =
    receiveData ReceivedDataFromJS



-- main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
