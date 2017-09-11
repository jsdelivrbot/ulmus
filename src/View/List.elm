module View.List exposing (list)

import Html exposing (Html, text, div)
import Bem exposing (Bem, bemToClass)

list : List String -> List a -> (a -> Html msg) -> Html msg
list mods rows rowFunc =
    div
        [ bemToClass (Bem "list" "" mods)
        ] (List.map rowFunc rows)