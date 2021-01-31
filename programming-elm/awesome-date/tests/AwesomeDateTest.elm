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
        [ test "retrives the year from a date" <|
            \_ -> Date.year exampleDate |> Expect.equal 2012
        ]
