module View exposing (view)

-- https://github.com/Zinggi/elm-2d-game-examples/blob/master/MarioLike.elm

import Browser.Dom exposing (getViewport)
import Color
import Debug
import Game.TwoD as Game
import Game.TwoD.Camera as Camera exposing (Camera)
import Game.TwoD.Render as Render exposing (Renderable, circle, rectangle)
import Geometry exposing (..)
import Html exposing (Html, div, text)
import Html.Attributes as Attr exposing (style)
import Messages exposing (Msg)
import Model exposing (GameState(..), Model, playerPos)
import String exposing (toInt)


viewPlayer : Vector -> Renderable
viewPlayer pos =
    let
        playerColor =
            Color.green

        playerSpritePos =
            ( pos.x - 0.25, pos.y - 0.25 )
    in
    Render.shape rectangle { color = playerColor, position = playerSpritePos, size = ( 0.5, 0.5 ) }


viewBackground : Vector -> Renderable
viewBackground gameWorldSize =
    let
        -- set size of background to cover the canvas exactly
        size =
            Vector gameWorldSize.x gameWorldSize.y

        pos =
            scale 0.5 <| flip size
    in
    Render.shape rectangle { color = Color.white, position = ( pos.x, pos.y ), size = ( size.x, size.y ) }


camera : Vector -> Camera
camera gameWorldSize =
    -- width times height of scene units!
    Camera.fixedArea (gameWorldSize.x * gameWorldSize.y) ( 0, 0 )


view : Model -> Html Msg
view model =
    let
        -- scale canvas to have the same aspect ratio as our camera?
        aspectRatio =
            model.world.size.y / model.world.size.x

        canvasWidth =
            round model.screenSize.x

        canvasHeight =
            round (model.screenSize.x * aspectRatio)
    in
    div [ Attr.style "overflow" "hidden", Attr.style "width" "100vw", Attr.style "height" "100vh", style "background-color" "black" ]
        [ Game.renderCentered { time = 0, camera = camera model.world.size, size = ( canvasWidth, canvasHeight ) }
            [ viewPlayer <| playerPos model
            , viewBackground model.world.size
            ]
        ]
