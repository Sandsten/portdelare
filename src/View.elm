module View exposing (view)

-- https://github.com/Zinggi/elm-2d-game-examples/blob/master/MarioLike.elm

import Browser.Dom exposing (getViewport)
import Color
import Debug exposing (log)
import Game.Resources as Resources exposing (Resources)
import Game.TwoD as Game
import Game.TwoD.Camera as Camera exposing (Camera)
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


newCameraPos : Camera -> Vector -> Camera
newCameraPos camera playerPosition =
    let
        ( cameraPositionX, cameraPositionY ) =
            Camera.getPosition camera

        cameraPosition =
            Vector cameraPositionX cameraPositionY

        cameraToPlayer =
            subtract playerPosition cameraPosition

        cameraDistanceToPlayer =
            norm cameraToPlayer

        maxDistanceFromPlayer =
            2.0

        newPos =
            add playerPosition (scale maxDistanceFromPlayer (flip (normalise cameraToPlayer)))
    in
    if cameraDistanceToPlayer > maxDistanceFromPlayer then
        -- Camera.moveTo ( newPos.x, newPos.y ) camera
        camera

    else
        camera


newCameraPos2 : Model -> Camera -> Vector -> Camera
newCameraPos2 model camera cameraSize =
    let
        leftBound =
            -model.world.size.x / 2 + (cameraSize.x / 2)

        rightBound =
            model.world.size.x / 2 - (cameraSize.x / 2)

        upperBound =
            model.world.size.y / 2 + (cameraSize.y / 2)

        lowerBound =
            -model.world.size.y / 2 - (cameraSize.x / 2)
    in
    if model.player.pos.x >= rightBound || model.player.pos.x <= leftBound || model.player.pos.y > upperBound || model.player.pos.y < lowerBound then
        camera

    else
        -- Camera.moveTo ( model.player.pos.x, model.player.pos.y ) camera
        camera


getCamera : Model -> Camera
getCamera model =
    let
        cameraSize =
            scale 1 model.world.size

        camera =
            Camera.fixedArea (cameraSize.x * cameraSize.y) ( 0, 0 )
    in
    -- newCameraPos camera model.player.pos
    newCameraPos2 model camera cameraSize


render : Model -> List Renderable
render model =
    List.concat
        [ renderBackground model.resources
        , [ renderPlayer model.player.pos
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

        -- camera =
        --     Camera.moveTo ( model.player.pos.x, model.player.pos.y ) (createCamera model.world.size)
        camera =
            getCamera model
    in
    div [ Attr.style "overflow" "hidden", Attr.style "width" "100vw", Attr.style "height" "100vh", style "background-color" "black" ]
        [ Game.renderCentered { time = 0, camera = camera, size = ( canvasWidth, canvasHeight ) }
            (render model)
        ]
