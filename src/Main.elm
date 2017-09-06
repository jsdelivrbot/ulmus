module Main exposing (..)

import Html exposing (Html, text, div)
import Navigation exposing (Location)

type Page =
    Home
    | About
    | Contact

type alias Model =
    { helloWorld: String
    , page : Page
    }

type Msg =
    UrlChange Location
    | NoOp

initialModel : Page -> Model
initialModel initialPage =
    Model "Hello World" initialPage

init : Location -> (Model, Cmd Msg)
init location =
    (getPage location.hash |> initialModel, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        UrlChange location ->
            { model | page = (getPage location.hash)} ! [ Cmd.none ]
        _ ->
            (model, Cmd.none)


getPage : String -> Page
getPage hash =
    case hash of
        "#/about" ->
            About
        "#/contact" ->
            Contact
        _ ->
            Home

renderPages : Model -> Html Msg
renderPages model =
    case model.page of
        About ->
            about model
        _ ->
            home model


home : Model -> Html Msg
home model =
    div [] [ text "home" ]

about : Model -> Html Msg
about model =
    div [] [ text "about" ]

view : Model -> Html Msg
view model =
    div []
        [ renderPages model
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
