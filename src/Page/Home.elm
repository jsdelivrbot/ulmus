module Page.Home exposing (..)

import Html exposing (Html, div, text, a)

import View.Grid exposing (row, col)
import View.Link exposing (basicLink)
import View.Content exposing (pageHeader)

homeView : model -> Html msg
homeView model =
    row
        [ pageHeader "Create your character"
        , basicLink "#/notfound" "Go to FourOhFour"
        ]