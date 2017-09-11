module View.Content exposing (pageHeader, paragraph)

import Html exposing (Html, h1, text, p)
import Bem exposing (Bem, bemToClass)

header : List String -> String -> Html msg
header mods txt =
    h1
        [ bemToClass (Bem "header" "" mods) ]
        [ text txt ]

pageHeader : String -> Html msg
pageHeader =
    header ["page"]

paragraph : String -> Html msg
paragraph txt =
    p 
        [ bemToClass (Bem "paragraph" "" []) ]
        [ text txt ]