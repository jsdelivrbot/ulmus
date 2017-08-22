module Main exposing (..)

import Html exposing (Html, text, div, button, p, input, label)
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (class)
import AuctionFile exposing (AuctionFileResponse, AuctionFile, fetchAuctionFiles)
import Auction exposing (AuctionResponse, Auction, fetchAuctions)
import Http

type alias Model =
    { auctionFile : AuctionFile
    , auctions : List Auction
    , httpError : String
    }

type Msg =
    FetchAuctionDumpFiles (Result Http.Error AuctionFileResponse)
    | FetchAuctions (Result Http.Error AuctionResponse)
    | NoOp

initialModel : Model
initialModel =
    Model (AuctionFile "" 0) [] ""

init : (Model, Cmd Msg)
init =
    (initialModel, fetchAuctionFiles FetchAuctionDumpFiles)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        FetchAuctionDumpFiles (Ok auctionFileResponse) ->
            case (List.head auctionFileResponse.files) of
                Just auctionFile ->
                    ({ model | auctionFile = auctionFile }, fetchAuctions auctionFile.url FetchAuctions)
                Nothing ->
                    (model, Cmd.none)
        FetchAuctionDumpFiles (Err error) ->
            ({ model | httpError = handleHttpError error }, Cmd.none)
        _ ->
            (model, Cmd.none)

handleHttpError : Http.Error -> String
handleHttpError err =
    case err of
        _ ->
            "Something went wrong"


view : Model -> Html Msg
view model =
    div []
        [ (text model.auctionFile.url)
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
