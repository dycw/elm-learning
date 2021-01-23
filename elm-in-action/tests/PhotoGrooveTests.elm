module PhotoGrooveTests exposing (decoderTest, decoderTest2, decoderTest3)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode as Decode exposing (decodeValue)
import Json.Encode as Encode
import PhotoGroove exposing (Model, Msg(..), initialModel, photoDecoder, update)
import Test exposing (Test, fuzz, fuzz2, test)


decoderTest : Test
decoderTest =
    test "title defaults" <|
        \_ ->
            """{"url": "fruits.com", "size": 5}"""
                |> Decode.decodeString photoDecoder
                |> Result.map .title
                |> Expect.equal (Ok "(untitled)")


decoderTest2 : Test
decoderTest2 =
    test "title defaults; v2" <|
        \_ ->
            [ ( "url", Encode.string "fruits.com" )
            , ( "size", Encode.int 5 )
            ]
                |> Encode.object
                |> decodeValue PhotoGroove.photoDecoder
                |> Result.map .title
                |> Expect.equal (Ok "(untitled)")


decoderTest3 : Test
decoderTest3 =
    fuzz2 string int "title defaults; v3" <|
        \url size ->
            [ ( "url", Encode.string url )
            , ( "size", Encode.int size )
            ]
                |> Encode.object
                |> decodeValue PhotoGroove.photoDecoder
                |> Result.map .title
                |> Expect.equal (Ok "(untitled)")


slidHueSetsHue : Test
slidHueSetsHue =
    fuzz int "SlidHue sets the hue" <|
        \amount ->
            initialModel
                |> update (SlidHue amount)
                |> Tuple.first
                |> .hue
                |> Expect.equal amount
