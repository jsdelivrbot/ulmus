module View.Grid exposing (..)

import Html exposing (Html, div)
import Bem exposing (Bem, bemToClass)
import Html.Attributes exposing (style)

row : List (Html msg) -> Html msg
row children =
    div
        [ bemToClass (Bem "row" "" [])
        ] children 


col : String -> List (Html msg) -> Html msg
col size children =
    div
        [ bemToClass (Bem "col" "" [])
        , style [("flex", size)]
        ] children 