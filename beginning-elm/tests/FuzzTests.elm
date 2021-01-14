module FuzzTests exposing (addOneTests, addTests, arrayGetTests, arrayGetTests2, flipTests, listLengthTests, multiplyFloatTests, pizzaLeftTests, stringTests)

import Array
import Expect exposing (Expectation)
import Fuzz exposing (..)
import Test exposing (..)


addOneTests : Test
addOneTests =
    describe "test addOne"
        [ fuzz int "adds 1 to any integer" <|
            \num ->
                addOne num |> Expect.equal (num + 1)
        , test "when 1 is added to 2, the result is 3" <|
            \_ ->
                addOne 2 |> Expect.equal 3
        , fuzzWith { runs = 200 } int "adds 1 to the given integer" <|
            \x -> addOne x |> Expect.equal (x + 1)
        , fuzz (intRange -100 100) "adds 1 to the given integer; intRange" <|
            \x -> addOne x |> Expect.equal (x + 1)
        , fuzz frequencyFuzzer "adds 1 to the given integer; custom freq" <|
            \x -> addOne x |> Expect.equal (x + 1)
        ]


addOne : Int -> Int
addOne x =
    1 + x


add : Int -> Int -> Int
add x y =
    x + y


addTests : Test
addTests =
    describe "add"
        [ fuzz2 int int "adds two given integers" <|
            \num1 num2 ->
                add num1 num2
                    |> Expect.equal (num1 + num2)
        ]


type alias FuzzOptions =
    { runs : Int }


frequencyFuzzer : Fuzzer Int
frequencyFuzzer =
    frequency
        [ ( 70, constant 7 )
        , ( 12, intRange 8 9 )
        , ( 6, constant 6 )
        , ( 9, intRange 2 4 )
        , ( 1, constant 5 )
        , ( 1, constant 1 )
        , ( 1, constant 10 )
        ]


flip : Bool -> Bool
flip x =
    not x


flipTests : Test
flipTests =
    describe "flip"
        [ fuzz bool "negates the given boolean value" <|
            \value ->
                flip value |> Expect.equal (not value)
        ]


multiplyFloat : Float -> Int -> Float
multiplyFloat x y =
    x * toFloat y


multiplyFloatTests : Test
multiplyFloatTests =
    describe "multiplyFloat"
        [ fuzz2 float int "multiplies given numbers" <|
            \x y ->
                multiplyFloat x y
                    |> Expect.within (Expect.Absolute 0.0000001) (x * toFloat y)
        ]


pizzaLeft : Float -> Float -> Float
pizzaLeft eatenPercent totalSlices =
    totalSlices - (eatenPercent * totalSlices)


pizzaLeftTests : Test
pizzaLeftTests =
    describe "pizzaLeft"
        [ fuzz2 percentage float "returns remaining pizza slices" <|
            \eaten total ->
                pizzaLeft eaten total
                    |> Expect.within (Expect.Absolute 0.000000001) (total - (eaten * total))
        ]


stringTests : Test
stringTests =
    describe "The String module"
        [ describe "String.reverse"
            [ test "has no effect on a palindrome" <|
                -- Unit Test - 1
                \_ ->
                    let
                        palindrome =
                            "hannah"
                    in
                    palindrome
                        |> String.reverse
                        |> Expect.equal palindrome
            , test "reverses a known string" <|
                -- Unit Test - 2
                \_ ->
                    "ABCDEFG"
                        |> String.reverse
                        |> Expect.equal "GFEDCBA"
            , fuzz string "restores the original string if you run it again" <|
                -- Fuzz Test
                \randomlyGeneratedString ->
                    randomlyGeneratedString
                        |> String.reverse
                        |> String.reverse
                        |> Expect.equal randomlyGeneratedString
            ]
        ]


listLengthTests : Test
listLengthTests =
    describe "List.length"
        [ fuzz (list int) "never returns a negative value" <|
            \intList ->
                intList
                    |> List.length
                    |> Expect.atLeast 0
        ]


arrayGetTests2 : Test
arrayGetTests2 =
    describe "Array.get"
        [ fuzz (array (intRange -20 20)) "returns Nothing for out of range index" <|
            \intArray ->
                let
                    length =
                        Array.length intArray
                in
                intArray
                    |> Array.get length
                    |> Expect.equal Nothing
        ]
        [ fuzz (tuple ( int, int )) "adds two given integers" <|
            \( num1, num2 ) ->
                add num1 num2
                    |> Expect.equal (num1 + num2)
        ]
