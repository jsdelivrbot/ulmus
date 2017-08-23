module Auction exposing (..)

import Json.Decode as Decode exposing (Decoder, map, map2, string, int, list, field)
import Http exposing (Error, Request, send, get)
import Regex exposing (Regex, regex)
import Task exposing (Task)

type alias AuctionFile =
    { url : String
    , lastModified : Int
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

type TimeLeft =
    Short
    | Medium
    | Long
    | VeryLong

type alias Realm =
    { name : String
    , slug : String
    }

type alias AuctionFileResponse =
    { files : AuctionFile
    }

type alias AuctionResponse =
    { realms : List Realm
    , auctions : List Auction
    }

fetchAuctions : (Result Http.Error AuctionResponse -> msg) -> Cmd msg
fetchAuctions msg =
    Http.toTask auctionFilesRequest
    |> Task.andThen (auctionsRequest >> Http.toTask)
    |> Task.attempt msg

auctionFilesRequest : Request AuctionFileResponse
auctionFilesRequest =
    get
        "https://us.api.battle.net/wow/auction/data/medivh?locale=en_US&apikey=xe68j3g8txkukntygqduvrbm4vjqcxg6"
        auctionFilesDecoder

auctionsRequest : AuctionFileResponse -> Request AuctionResponse
auctionsRequest auctionFileResponse =
    get ("http://localhost:8085?url=" ++ auctionFileResponse.files.url) auctionResponseDecoder

-- Decoders
auctionFilesDecoder : Decoder AuctionFileResponse
auctionFilesDecoder =
    map AuctionFileResponse
        (field "files" (Decode.index 0 auctionFileDecoder))

auctionFileDecoder : Decoder AuctionFile
auctionFileDecoder =
    map2 AuctionFile
        (field "url" string)
        (field "lastModified" int)

auctionResponseDecoder : Decoder AuctionResponse
auctionResponseDecoder =
    map2 AuctionResponse
        (field "realms" (list realmDecoder))
        (field "auctions" (list auctionDecoder))

realmDecoder : Decoder Realm
realmDecoder =
    map2 Realm
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
