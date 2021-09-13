module View exposing (view)

-- https://github.com/Zinggi/elm-2d-game-examples/blob/master/MarioLike.elm

import Browser.Dom exposing (getViewport)
import Color
import Game.TwoD as Game
import Game.TwoD.Camera as Camera exposing (Camera)
import Game.TwoD.Render as Render exposing (Renderable, circle, rectangle)
import Geometry exposing (Vector)
import Html exposing (Html, div, text)
import Html.Attributes as Attr
import Messages exposing (Msg)
import Model exposing (GameState(..), Model, playerPos)


viewPlayer : Vector -> Renderable
viewPlayer pos =
    let
        playerColor =
            Color.green

        playerPosition =
            ( pos.x, pos.y )
    in
    Render.shape rectangle { color = playerColor, position = playerPosition, size = ( 0.5, 0.5 ) }


camera : Camera
camera =
    Camera.fixedWidth 8 ( 0, 0 )


view : Model -> Html Msg
view model =
    div [ Attr.style "overflow" "hidden", Attr.style "width" "100vw", Attr.style "height" "100vh" ]
        [ Game.renderCentered { time = 0, camera = camera, size = ( model.screenSize.w, model.screenSize.h ) }
            [ viewPlayer <| playerPos model
            ]
        ]
