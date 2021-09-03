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
-- import Task

-- We need to write Model and View
import Model exposing (Model)
import View
-- import View.Font as Font
-- import View.Sprite as Sprite
import Messages exposing (Msg(..))


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
    ]
-- Mogee example:
-- [ onAnimationFrameDelta Animate
--         , onKeyDown (Decode.map (KeyChange True) keyCode)
--         , onKeyUp (Decode.map (KeyChange False) keyCode)
--         , onResize Resize
--         , onVisibilityChange VisibilityChange
--         , gamepad (Gamepad.fromJson >> GamepadChange)
--         ]

init : Value -> (Model, Cmd Msg)
init _ =
  (
   ( Model.initial, Cmd.none )
  )
-- Instead of Cmd.none, Mogee has:
-- Cmd.batch
--         [ Sprite.loadSprite SpriteLoaded
--         , Font.load FontLoaded
--         , Task.perform (\{ viewport } -> Resize (round viewport.width) (round viewport.height)) getViewport
--         ]