module Page exposing (..)

import Html exposing (Html)
import Page.Home exposing (homeView)
import Page.FourOhFour exposing (fourOhFourView)

type Page msg
    = Home (Html msg)
    | Login (Html msg)
    | Register (Html msg)
    | FourOhFour (Html msg)

getPageFromUrl : String -> model -> (Html msg)
getPageFromUrl url model =
    case url of
        "#/home" ->
            homeView model
        _ ->
            fourOhFourView model