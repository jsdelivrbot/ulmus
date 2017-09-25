module View.MindMap exposing (..)

import Html exposing (Attribute, Html, div, text, input, textarea)
import Html.Events exposing (onInput, on)
import Mouse exposing (Position)
import Html.Attributes exposing (class, contenteditable, style, value)
import Model exposing (Msg(..), Bubble(..), BubblePath)
import Json.Decode as Decode exposing (Decoder)
import Markdown exposing (toHtml)
import Window
import Task

mindMap : (Int, Int) -> Bubble -> Html Msg
mindMap (width, height) bubble =
    div [ class "mm"
        , buildSizeStyle (width, height)
        ]
        [ thoughtField bubble
        ]

buildSizeStyle : (Int, Int) -> Attribute Msg
buildSizeStyle (width, height) =
    style [("width", toString width ++ "px"), ("height", toString height ++ "px")]

getWidth : Cmd Msg
getWidth =
    Task.perform GetWidth Window.width

getHeight : Cmd Msg
getHeight =
    Task.perform GetHeight Window.height

thoughtField : Bubble -> Html Msg
thoughtField bubble =
    case bubble of
        Child body position path ->
            thoughtBubble body position path []
        Parent body position path children ->
            thoughtBubble body position path children

inputDecoder : Decoder String
inputDecoder =
    Decode.at ["target", "textContent"] Decode.string

thoughtBubble : String -> Position -> BubblePath -> List Bubble -> Html Msg
thoughtBubble body position path children =
    let
        _ = Debug.log "" children
    in
    div
        [ class "mm__field"
        , style [ ("top", toString position.y ++ "px"), ("left", toString position.x ++ "px") ]
        ]
        [ textarea [ onInput (\str -> BubbleBodyChange str path), value body, class "mm__editor"] []
        , div 
            [ class "mm__field__editable"
            ] [body |> toHtml []]
        , div [] (List.map thoughtField children)
        ]

topButton : Html Msg
topButton =
    div [ class "mm__button--top" ] []

bottomButton : Html Msg
bottomButton =
    div [ class "mm__button--bottom" ] []