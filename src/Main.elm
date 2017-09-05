module Main exposing (..)

import Html exposing (Html, text, div, button, p, input, label)
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (class)
import Http

import Pokemon exposing (Pokemon, PokemonSprite, fetchPokemon, pokemonView)

type alias Model =
    { helloWorld: String
    }

type Msg =
    | NoOp

initialModel : Model
initialModel =
    Model "Hello World"

init : (Model, Cmd Msg)
init =
    (initialModel, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        _ ->
            (model, Cmd.none)


view : Model -> Html Msg
view model =
    div []
        [ text model.helloWorld
        ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
