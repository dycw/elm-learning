module PhotoGrooveTests exposing (decoderTest)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode as Decode
import Json.Encode as Encode
import PhotoGroove exposing (photoDecoder)
import Test exposing (Test, test)


decoderTest : Test
decoderTest =
    test "title defaults" <|
        \_ ->
            """{"url": "fruits.com", "size": 5}"""
                |> Decode.decodeString photoDecoder
                |> Result.map .title
                |> Expect.equal (Ok "(untitled)")
