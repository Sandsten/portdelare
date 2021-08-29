-- Inspiration: https://github.com/w0rm/elm-mogee

module Main exposing (main)

-- imports removec from button example
-- import Html exposing (Html, button, div, text)
-- import Html.Events exposing (onClick)

import Browser
import Browser.Dom exposing (getViewport)
import Browser.Events exposing
  ( onAnimationFrameDelta
  , onKeyDown
  , onKeyUp
  , onResize
  , onVisibilityChange
  )
import Html.Events exposing (keyCode)
import Json.Decode as Decode exposing (Value)
import Messages exposing (Msg(..))
import Task

-- We need to write Model and View
import Model exposing (Model) 
import View
import View.Font as Font
import View.Sprite as Sprite

-- Removing for now, not sure if really needed yet:
-- import Ports exposing (gamepad)


-- MAIN
main: Program Value Model Msg
main =
  Browser.element
    { init = init
    , subscriptions = subscriptions
    , update = Model.update
    , view = View.view
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.batch
    [
      later
    ]

init : Value -> (Model, Cmd Msg)
init _ =
  (
    later
  )