-- Inspiration: https://github.com/w0rm/elm-mogee


module Main exposing (main)

-- -- Removed imports from Mogee
-- import Task
-- import View.Font as Font
-- import View.Sprite as Sprite
-- import Ports exposing (gamepad)

import Browser
import Browser.Dom exposing (getViewport)
import Browser.Events
    exposing
        ( onAnimationFrameDelta
        , onKeyDown
        , onKeyUp
        , onResize
        , onVisibilityChange
        )
import Html.Events exposing (keyCode)
import Json.Decode as Decode exposing (Value)
import Messages exposing (Msg(..))
import Model exposing (Model)
import View


main : Program Value Model Msg
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
        [ onAnimationFrameDelta Animate
        , onKeyDown (Decode.map (KeyChange True) keyCode)
        , onKeyUp (Decode.map (KeyChange False) keyCode)
        , onResize Resize
        ]



-- -- Mogee example Sub.batch:
-- [ onAnimationFrameDelta Animate
--         , onKeyDown (Decode.map (KeyChange True) keyCode)
--         , onKeyUp (Decode.map (KeyChange False) keyCode)
--         , onResize Resize
--         , onVisibilityChange VisibilityChange
--         , gamepad (Gamepad.fromJson >> GamepadChange)
--         ]


init : Value -> ( Model, Cmd Msg )
init _ =
    ( Model.initial, Cmd.none )



-- -- Instead of `Cmd.none` in `init`, Mogee has:
-- Cmd.batch
--         [ Sprite.loadSprite SpriteLoaded
--         , Font.load FontLoaded
--         , Task.perform (\{ viewport } -> Resize (round viewport.width) (round viewport.height)) getViewport
--         ]
