module Model exposing (..)

import Navigation exposing (Location)
import Mouse exposing (Position)
import Keyboard exposing (KeyCode)
import Window exposing (Size)
import Set exposing (Set)
import Html exposing (Html)

type Msg =
    NewBubble
    | GetWidth Int
    | GetHeight Int
    | WindowResize Size
    | BubbleBodyChange String BubblePath
    | UrlChange Location
    | KeyDown KeyCode
    | KeyUp KeyCode
    | NoOp


type alias BubblePath = List Int

type Bubble =
    Child String Position BubblePath
    | Parent String Position BubblePath (List Bubble)

type alias Model =
    { path : String
    , width : Int
    , height : Int
    , rootBubble : Bubble
    , keys : Set KeyCode
    }