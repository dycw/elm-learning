module AwesomeDateTest exposing (suite)

import AwesomeDate as Date exposing (Date)
import Expect
import Test exposing (..)


exampleDate : Date
exampleDate =
    Date.create 2012 6 2


suite : Test
suite =
    describe "AwesomeDate"
        [ testDateParts
        , testIsLeapYear
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
        ]
