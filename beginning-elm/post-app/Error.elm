module Error exposing (buildErrorMessage)

import Http


buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl string ->
            string

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "Unable to reach server."

        Http.BadStatus int ->
            "Request failed with status code: " ++ String.fromInt int

        Http.BadBody string ->
            string
