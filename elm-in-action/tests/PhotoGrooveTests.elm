module PhotoGrooveTests exposing (..)

import Expect exposing (Expectation, equal)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (Test, test)


suite : Test
suite =
    test "first test" (\_ -> equal 2 (1 + 1))
