module Main exposing (..)

import Html exposing (Html, text, div, button, p, input, label)
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (class)
import Auction exposing (AuctionResponse, Auction, AuctionFile, fetchAuctions)
import Http

type alias Model =
    { auctionFile : AuctionFile
    , auctions : List Auction
    , httpError : String
    }

type Msg =
    FetchAuctions (Result Http.Error AuctionResponse)
    | NoOp

initialModel : Model
initialModel =
    Model (AuctionFile "" 0) [] ""

init : (Model, Cmd Msg)
init =
    (initialModel, fetchAuctions FetchAuctions)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        FetchAuctions (Ok response) ->
            Debug.log "Good to go" |> always ({model | auctions = response.auctions}, Cmd.none)
        FetchAuctions (Err error) ->
            Debug.log "Error" error |> always (model, Cmd.none)
        _ ->
            (model, Cmd.none)

handleHttpError : Http.Error -> String
handleHttpError err =
    case err of
        Http.BadUrl str ->
            "There was a bad url given"
        Http.BadStatus resp ->
            resp.status.message
        _ ->
            "Something went wrong"


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text "Currently loading auction" ]
        , (text model.auctionFile.url)
        , text model.httpError
        ]

renderFileUrl : Maybe AuctionFile -> Html msg
renderFileUrl auctionFile =
    case auctionFile of
        Just file ->
            div []
                [ text file.url
                ]
        Nothing ->
            text ""


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
