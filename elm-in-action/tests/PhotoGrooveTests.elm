module PhotoGrooveTests exposing (decoderTest)

import Expect exposing (Expectation, equal)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode exposing (decodeString)
import PhotoGroove exposing (photoDecoder)
import Test exposing (Test, test)


decoderTest : Test
decoderTest =
    test "title defaults" <|
        \_ ->
            """{"url": "fruits.com", "size": 5}"""
                |> decodeString photoDecoder
                |> Result.map .title
                |> equal (Ok "(untitled)")
