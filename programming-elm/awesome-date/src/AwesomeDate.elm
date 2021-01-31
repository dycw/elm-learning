module AwesomeDate exposing (Date, create, isLeapYear, year)


type Date
    = Date { year : Int, month : Int, day : Int }


create : Int -> Int -> Int -> Date
create year_ month_ day_ =
    Date { year = year_, month = month_, day = day_ }


year : Date -> Int
year (Date date) =
    date.year


isLeapYear : Int -> Bool
isLeapYear year_ =
    let
        isDivisibleBy n =
            remainderBy n year_ == 0
    in
    isDivisibleBy 4
