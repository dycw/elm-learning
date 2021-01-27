module PhotoGrooveTests exposing
    ( clickThumbnail
    , decoderTest
    , decoderTest2
    , decoderTest3
    , noPhotosNoThumbnails
    , slidHueSetsHue
    , sliders
    , thumbnailsWork
    )

import Expect
    exposing
        ( Expectation
        )
import Fuzz
    exposing
        ( Fuzzer
        , int
        , string
        )
import Html.Attributes as Attr
import Json.Decode as Decode
    exposing
        ( decodeValue
        )
import Json.Encode as Encode
import PhotoGallery
    exposing
        ( Model
        , Msg(..)
        , Photo
        , Status(..)
        , initialModel
        , photoDecoder
        , update
        , urlPrefix
        , view
        )
import Test
    exposing
        ( Test
        , describe
        , fuzz
        , fuzz2
        , fuzz3
        , test
        )
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector
    exposing
        ( attribute
        , tag
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
                |> decodeValue PhotoGallery.photoDecoder
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
                |> decodeValue PhotoGallery.photoDecoder
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
                |> PhotoGallery.view
                |> Query.fromHtml
                |> Query.findAll [ tag "img" ]
                |> Query.count (Expect.equal 0)


thumbnailRendered : String -> Query.Single msg -> Expectation
thumbnailRendered url query =
    query
        |> Query.findAll [ tag "img", attribute (Attr.src (urlPrefix ++ url)) ]
        |> Query.count (Expect.atLeast 1)


photoFromUrl : String -> Photo
photoFromUrl url =
    { url = url, size = 0, title = "" }


thumbnailsWork : Test
thumbnailsWork =
    fuzz urlFuzzer "URLs render as thumbnails" <|
        \urls ->
            let
                thumbnailChecks : List (Query.Single msg -> Expectation)
                thumbnailChecks =
                    List.map thumbnailRendered urls
            in
            { initialModel | status = Loaded (List.map photoFromUrl urls) "" }
                |> view
                |> Query.fromHtml
                |> Expect.all thumbnailChecks


urlFuzzer : Fuzzer (List String)
urlFuzzer =
    let
        toPng : Int -> String
        toPng n =
            String.fromInt n ++ ".png"

        urlsFromCount : Int -> List String
        urlsFromCount urlCount =
            List.range 1 urlCount |> List.map toPng
    in
    Fuzz.intRange 1 5 |> Fuzz.map urlsFromCount


clickThumbnail : Test
clickThumbnail =
    fuzz3 urlFuzzer string urlFuzzer "clicking a thumbnail select it" <|
        \urlsBefore urlToSelect urlsAfter ->
            let
                url =
                    urlToSelect ++ ".jpeg"

                photos =
                    (urlsBefore ++ url :: urlsAfter) |> List.map photoFromUrl

                srcToClick =
                    urlPrefix ++ url
            in
            { initialModel | status = Loaded photos "" }
                |> view
                |> Query.fromHtml
                |> Query.find [ tag "img", attribute (Attr.src srcToClick) ]
                |> Event.simulate Event.click
                |> Event.expect (ClickedPhoto url)
