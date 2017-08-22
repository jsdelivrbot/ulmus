module Auction exposing (..)

import Json.Decode as Decode exposing (Decoder, map, map2, string, int, list, field)
import Http exposing (Error, Request, send, get)
import Regex exposing (Regex, regex)

type TimeLeft =
    Short
    | Medium
    | Long
    | VeryLong

type alias AuctionResponse =
    { realms : List Realm
    , auctions : List Auction
    }

type alias Realm =
    { name : String
    , slug : String
    }

type alias Auction =
    { auc : Int
    , item : Int
    , owner : String
    , bid : Int
    , buyout : Int
    , quantity : Int
    , timeLeft : String
    }

fetchAuctions : String -> (Result Http.Error AuctionResponse -> msg) -> Cmd msg
fetchAuctions url msg =
    case (auctionsRequest url) of
        Ok request ->
            send msg request
        Err error ->
            Cmd.none

auctionsRequest : String -> Result String (Request AuctionResponse)
auctionsRequest url =
    case getPath <| auctionDumpFilePath url of
        Ok path ->
            Ok (get ("http://localhost:8085" ++ path) auctionResponseDecoder)
        Err error ->
            Err error

getPath : List Regex.Match -> Result String String
getPath matches =
    case List.head matches of
        Just {submatches} ->
            case List.head submatches of
                Just path ->
                    Ok path
                Nothing ->
                    Err "Path found in matches"
        Nothing ->
            Err "No matches"



auctionDumpFilePath : String -> List Regex.Match
auctionDumpFilePath url=
    Regex.find (Regex.AtMost 1) (regex "/worldofwarcraft\\.com(.*)/") url

auctionResponseDecoder : Decoder AuctionResponse
auctionResponseDecoder =
    Decode.map2 AuctionResponse
        (field "realms" (list realmDecoder))
        (field "auctions" (list auctionDecoder))


realmDecoder : Decoder Realm
realmDecoder =
    Decode.map2 Realm
        (field "name" string)
        (field "slug" string)

auctionDecoder : Decoder Auction
auctionDecoder =
    Decode.map7 Auction
        (field "auc" int)
        (field "item" int)
        (field "owner" string)
        (field "bid" int)
        (field "buyout" int)
        (field "quantity" int)
        (field "timeLeft" string)
