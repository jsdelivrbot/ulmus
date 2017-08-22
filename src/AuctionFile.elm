module AuctionFile exposing (..)

import Json.Decode as Decode exposing (Decoder, map, map2, string, int, list, field)
import Http exposing (Error, Request, send, get)

type alias AuctionFile =
    { url : String
    , lastModified : Int
    }

type alias AuctionFileResponse =
    { files : (List AuctionFile)
    }

fetchAuctionFiles : (Result Http.Error AuctionFileResponse -> msg) -> Cmd msg
fetchAuctionFiles msg =
    send msg auctionFilesRequest

auctionFilesRequest : Request AuctionFileResponse
auctionFilesRequest =
    get
        "https://us.api.battle.net/wow/auction/data/medivh?locale=en_US&apikey=xe68j3g8txkukntygqduvrbm4vjqcxg6"
        auctionFilesDecoder

auctionFilesDecoder : Decoder AuctionFileResponse
auctionFilesDecoder =
    map AuctionFileResponse
        (field "files" (list auctionFileDecoder))

auctionFileDecoder : Decoder AuctionFile
auctionFileDecoder =
    map2 AuctionFile
        (field "url" string)
        (field "lastModified" int)
