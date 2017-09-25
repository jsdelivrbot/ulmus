module Main exposing (..)

import Html exposing (Html, text, div)
import Model exposing (Model, Msg(..), Bubble(..), BubblePath)
import Page exposing (Page, getPageFromUrl)
import View.MindMap exposing (mindMap, getWidth, getHeight)
import Navigation exposing (Location)
import Window exposing (resizes)
import Keyboard exposing (downs, KeyCode)
import Mouse exposing (ups, Position)
import Char exposing (toCode, fromCode)
import Set exposing (Set)
import Ports exposing (tabKeyDown)


newParent : Int -> Int -> BubblePath -> Bubble
newParent x y path =
    Parent "Your idea here" (Position x y) path []

newChild : Int -> Int -> String -> BubblePath -> Bubble
newChild x y body path =
    Child body (Position x y) path

initialModel : String -> Model
initialModel path =
    Model path 200 200 (newParent 0 0 []) Set.empty

init : Location -> (Model, Cmd Msg)
init location =
    (initialModel location.hash, Cmd.batch [ getWidth, getHeight ])

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NewBubble ->
            { model | rootBubble = addBubble model.rootBubble } ! [ Cmd.none ]
        UrlChange location ->
            { model | path = location.hash } ! [ Cmd.none ]
        GetWidth width ->
            { model | width = width*2, rootBubble = setRootLeft model.rootBubble width } ! [ Cmd.none ]
        GetHeight height ->
            { model | height = height*2, rootBubble = setRootTop model.rootBubble height } ! [ Cmd.none ]
        BubbleBodyChange txt path ->
            { model | rootBubble = setBubbleBody model.rootBubble txt} ! [ Cmd.none ]
        _ ->
            (model, Cmd.none)

-- mapBubble : List Bubble -> BubblePath -> (Bubble -> Bubble) -> Bubble
-- mapBubble bubbles selector editFunc =
    -- case bubble of
    --     Parent _ _ path children ->
    --         if selector == path then (editFunc bubble) else mapBubble bubble selector 
    --     Child _ _ path ->
    --         if selector == path then (editFunc bubble) else mapBubble bubble


setBubbleBody : Bubble -> String -> Bubble
setBubbleBody bubble newBody =
    case bubble of
        Parent body position path children ->
            Parent newBody position path children
        Child body position path ->
            Child newBody position path

setRootLeft : Bubble -> Int -> Bubble
setRootLeft root width =
    case root of
        Parent body position path children ->
            Parent body (Position (toFloat width / 2 |> floor) position.y) path children
        _ ->
            root

setRootTop : Bubble -> Int -> Bubble
setRootTop root height =
    case root of
        Parent body position path children ->
            Parent body (Position position.x (toFloat height / 2 |> floor)) path children
        _ ->
            root

buildChildPath : BubblePath -> BubblePath
buildChildPath path =
    List.append path [List.length path]

addBubble : Bubble -> Bubble
addBubble parent =
    case parent of
        Child body pos path ->
            buildChildPath path
            |> newChild (pos.x) (pos.y) "Empty"
            |> List.singleton
            |> Parent body pos path
        Parent body pos path children ->
            buildChildPath path
            |> newChild (pos.x) (pos.y) "Empty"
            |> List.singleton
            |> List.append children
            |> Parent body pos path
            
view : Model -> Html Msg
view model =
    div []
        [ mindMap (model.width, model.height) model.rootBubble
        ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ resizes WindowResize
        , Keyboard.downs KeyDown
        , tabKeyDown (\_ -> NewBubble)
        ]

main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
