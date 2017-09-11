module Bem exposing (Bem, bemToClass)

import Html exposing (Attribute)
import Html.Attributes exposing (class)

type alias Bem =
    { base : String
    , block : String
    , modifiers : List String
    }

bemToClass : Bem -> Attribute msg
bemToClass bem =
    class <| bem.base ++ bem.block ++ " " ++ (mapModifiers bem.base bem.modifiers)

mapModifiers : String -> List String -> String
mapModifiers base mods =
    List.foldl (\(mod) -> concatBaseWithMod base mod) "" mods

concatBaseWithMod : String -> String -> String -> String
concatBaseWithMod base mod _ =
    base ++ "--" ++ mod