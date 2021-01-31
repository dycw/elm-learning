module AppTest exposing (suite)

import App
import AwesomeDate as Date exposing (Date)
import Expect
import Html.Attributes exposing (type_, value)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, id, tag, text)


selectedDate : Date
selectedDate =
    Date.create 2012 6 2


futureDate : Date
futureDate =
    Date.create 2015 9 21


initialModel : App.Model
initialModel =
    { selectedDate = selectedDate
    , years = Nothing
    , months = Nothing
    , days = Nothing
    }


modelWithDateOffsets : App.Model
modelWithDateOffsets =
    { initialModel
        | years = Just 3
        , months = Just 2
        , days = Just 50
    }


selectDate : Date -> App.Msg
selectDate date =
    App.SelectDate (Just date)


changeDateOffset : App.DateOffsetField -> Int -> App.Msg
changeDateOffset field amount =
    App.ChangeDateOffset field (Just amount)


testUpdate : Test
testUpdate =
    describe "update"
        [ test "selects a date" <|
            \_ ->
                App.update (selectDate futureDate) initialModel
                    |> Tuple.first
                    |> Expect.equal { initialModel | selectedDate = futureDate }
        ]


testView : Test
testView =
    describe "view"
        [ test "displays the selected data" <|
            \_ ->
                App.view initialModel
                    |> Query.fromHtml
                    |> Query.find [ tag "input", attribute (type_ "date") ]
                    |> Query.has [ attribute (value "2012-06-02") ]
        ]


testEvents : Test
testEvents =
    todo "implement event tests"


suite : Test
suite =
    describe "App"
        [ testUpdate
        , testView
        , testEvents
        ]
