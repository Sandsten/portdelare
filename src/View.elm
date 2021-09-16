module View exposing (view)

-- https://github.com/Zinggi/elm-2d-game-examples/blob/master/MarioLike.elm
-- import Game.TwoD.Camera as Camera exposing (Camera)
-- import CameraRig as CameraRig exposing (CameraRig)

import Browser.Dom exposing (getViewport)
import Color
import Debug exposing (log)
import Game.Resources as Resources exposing (Resources)
import Game.TwoD as Game
import Game.TwoD.Render as Render exposing (Renderable, circle, rectangle)
import Geometry exposing (..)
import Html exposing (Html, div, text)
import Html.Attributes as Attr exposing (style)
import Messages exposing (Msg)
import Model exposing (GameState(..), Model, playerPos)
import String exposing (toInt)


renderPlayer : Vector -> Renderable
renderPlayer pos =
    let
        playerColor =
            Color.green

        playerSpritePos =
            ( pos.x - 0.25, pos.y - 0.25 )
    in
    Render.shape rectangle { color = playerColor, position = playerSpritePos, size = ( 0.5, 0.5 ) }


renderFloor : Vector -> Renderable
renderFloor worldSize =
    let
        floorThickness =
            1
    in
    Render.shape rectangle { color = Color.gray, position = ( -worldSize.x / 2, (-worldSize.y / 2) - floorThickness ), size = ( worldSize.x, floorThickness ) }


renderBackground : Resources -> List Renderable
renderBackground resources =
    [ Render.parallaxScroll
        { z = -0.99
        , texture = Resources.getTexture "images/rocks.png" resources
        , tileWH = ( 1, 1 )
        , scrollSpeed = ( 0.25, 0.25 )
        }
    ]



-- Idea: If player is outside a specific radius from the camera -> move camera towards player
-- TODO: Add target pos of camera and animate it towards the position


render : Model -> List Renderable
render model =
    List.concat
        [ renderBackground model.resources
        , [ renderPlayer model.player.pos
          , renderFloor model.world.size
          ]
        ]


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
        [ Game.renderCentered { time = 0, camera = model.cameraRig.camera, size = ( canvasWidth, canvasHeight ) }
            (render model)
        ]
