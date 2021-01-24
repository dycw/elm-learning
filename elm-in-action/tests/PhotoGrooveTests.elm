module PhotoGrooveTests exposing
    ( decoderTest
    , decoderTest2
    , decoderTest3
    , noPhotosNoThumbnails
    , slidHueSetsHue
    , sliders
    )

import Expect
    exposing
        ( Expectation
        )
import Fuzz
    exposing
        ( Fuzzer
        , int
        , list
        , string
        )
import Html.Attributes as Attr
    exposing
        ( src
        )
import Json.Decode as Decode
    exposing
        ( decodeValue
        )
import Json.Encode as Encode
import PhotoGroove
    exposing
        ( Model
        , Msg(..)
        , initialModel
        , photoDecoder
        , update
        , urlPrefix
        )
import Test
    exposing
        ( Test
        , describe
        , fuzz
        , fuzz2
        , test
        )
import Test.Html.Query as Query
import Test.Html.Selector
    exposing
        ( attribute
        , tag
        , text
        )


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


sliders : Test
sliders =
    describe "Slider sets the derised field in the Model"
        [ testSlider "SlidHue" SlidHue .hue
        , testSlider "SlidRipple" SlidRipple .ripple
        , testSlider "SlidNoise" SlidNoise .noise
        ]


testSlider : String -> (Int -> Msg) -> (Model -> Int) -> Test
testSlider description toMsg amountFromModel =
    fuzz int description <|
        \amount ->
            initialModel
                |> update (toMsg amount)
                |> Tuple.first
                |> amountFromModel
                |> Expect.equal amount


noPhotosNoThumbnails : Test
noPhotosNoThumbnails =
    test "No thumbnails render when there are no photos to render." <|
        \_ ->
            initialModel
                |> PhotoGroove.view
                |> Query.fromHtml
                |> Query.findAll [ tag "img" ]
                |> Query.count (Expect.equal 0)


thumbnailRendered : String -> Query.Single msg -> Expectation
thumbnailRendered url query =
    query
        |> Query.findAll [ tag "img", attribute (Attr.src (urlPrefix ++ url)) ]
        |> Query.count (Expect.atLeast 1)
