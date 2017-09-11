module Main exposing (..)

import Html exposing (Html, text, div)
import Model exposing (Model, Msg(..))
import Page exposing (Page, getPageFromUrl)
import Navigation exposing (Location)

initialModel : String -> Model
initialModel path =
    Model "Hello World" path

init : Location -> (Model, Cmd Msg)
init location =
    (initialModel location.hash, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        UrlChange location ->
            { model | path = location.hash } ! [ Cmd.none ]
        _ ->
            (model, Cmd.none)


view : Model -> Html Msg
view model =
    div []
        [ getPageFromUrl model.path model
        ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
