module View.Link exposing (..)

import Html.Attributes exposing (href)
import Html exposing (Html, text, a)
import Bem exposing (Bem, bemToClass)

basicLink : String -> String -> Html msg
basicLink to txt =
    a 
        [ href to
        , bemToClass (Bem "link" "" [])
        ]
        [ text txt
        ]