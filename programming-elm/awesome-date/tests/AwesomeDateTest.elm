module AwesomeDateTest exposing (suite)

import AwesomeDate as Date exposing (Date)
import Expect
import Fuzz exposing (Fuzzer, int, intRange)
import Random
import Shrink
import Test exposing (..)


exampleDate : Date
exampleDate =
    Date.create 2012 6 2


leapDate : Date
leapDate =
    Date.create 2012 2 29


dateFuzzer : Fuzzer ( Int, Int, Int )
dateFuzzer =
    let
        randomYear =
            Random.int Random.minInt Random.maxInt

        randomMonth =
            Random.int 1 12

        generator =
            Random.pair randomYear randomMonth
                |> Random.andThen
                    (\( year, month ) ->
                        Random.int 1 (Date.daysInMonth year month)
                            |> Random.map (\day -> ( year, month, day ))
                    )

        shrinker dateTuple =
            Shrink.tuple3 ( Shrink.int, Shrink.int, Shrink.int ) dateTuple
    in
    Fuzz.custom generator shrinker


suite : Test
suite =
    describe "AwesomeDate"
        [ testDateParts
        , testIsLeapYear
        , testAddYears
        , testToDateString
        ]


testDateParts : Test
testDateParts =
    describe "date part getters"
        [ test "retrives the year from a date" <|
            \_ -> Date.year exampleDate |> Expect.equal 2012
        ]


testIsLeapYear : Test
testIsLeapYear =
    describe "isLeapYear"
        [ test "returns true if divisible by 4 but not 100" <|
            \_ ->
                Date.isLeapYear 2012
                    |> Expect.true "Expected leap year"
        , test "returns false if not divisible by 4" <|
            \_ ->
                Date.isLeapYear 2010
                    |> Expect.false "Did not expect leap year"
        , test "returns false if divisible by 4 and 100 but not 400" <|
            \_ ->
                Date.isLeapYear 3000
                    |> Expect.false "Did not expect leap year"
        , test "returns true if divisible by 4, 100, and 400" <|
            \_ ->
                Date.isLeapYear 2000
                    |> Expect.true "Expected leap year"
        ]


testAddYears : Test
testAddYears =
    describe "addYears"
        [ test "changes a date's year" <|
            \_ ->
                Date.addYears 2 exampleDate
                    |> expectDate 2014 6 2
        , test "prevents leap days on non-leap years" <|
            \_ ->
                Date.addYears 1 leapDate
                    |> expectDate 2013 2 28
        , fuzz int "changes the year by the amount given" <|
            \years ->
                let
                    newDate =
                        Date.addYears years exampleDate
                in
                (Date.year newDate - Date.year exampleDate)
                    |> Expect.equal years
        ]


expectDate : Int -> Int -> Int -> Date -> Expect.Expectation
expectDate year month day actualDate =
    let
        expectedDate =
            Date.create year month day
    in
    if actualDate == expectedDate then
        Expect.pass

    else
        Expect.fail <|
            Date.toDateString actualDate
                ++ "\n ╷ \n │ expectDate\n ╵ \n"
                ++ Date.toDateString expectedDate


testToDateString : Test
testToDateString =
    describe "toDateString"
        [ fuzz dateFuzzer "creates a valid date string" <|
            \( year, month, day ) ->
                Date.create year month day
                    |> Date.toDateString
                    |> Expect.equal
                        (String.fromInt month
                            ++ "/"
                            ++ String.fromInt day
                            ++ "/"
                            ++ String.fromInt year
                        )
        ]
