module Model exposing (..)

import Navigation exposing (Location)

type Msg =
    UrlChange Location
    | NoOp

type alias Model =
    { helloWorld: String
    , path : String
    }