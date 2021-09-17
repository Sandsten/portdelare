module CameraRig exposing (..)

-- The idea is to have a camera rig with an attached camera.
-- All logic for how the camera can move etc should be determined by the camera rig.
-- More types could be defined such as follow speed, size etc..

import Color
import Game.TwoD.Camera as Cam exposing (..)
import Game.TwoD.Render as Render exposing (Renderable, circle, shape, triangle)
import Geometry exposing (..)
import Html.Attributes exposing (target)


type CameraBehaviour
    = FollowPlayer
    | Statonary


type alias CameraRig =
    { camera : Cam.Camera
    , size : Vector
    , followSpeed : Float
    , behaviour : CameraBehaviour
    , target : Vector
    , debugVisuals : Bool
    }


initial : Vector -> CameraRig
initial size =
    { camera = Cam.fixedArea (size.x * size.y) ( 0, 0 )
    , size = size
    , followSpeed = 0.001
    , behaviour = FollowPlayer
    , target = Vector 0 0
    , debugVisuals = True
    }


position : CameraRig -> Vector
position cameraRig =
    let
        ( x, y ) =
            Cam.getPosition cameraRig.camera
    in
    Vector x y


{-| Clamps a value in both directions. I.e x will be clamped to both clampVal and -clampVal
-}
clamp : Float -> Float -> Float
clamp x clampVal =
    if x >= clampVal then
        clampVal

    else if x <= -clampVal then
        -clampVal

    else
        x


move : CameraRig -> Vector -> Vector -> Float -> CameraRig
move cameraRig pPos worldSize elapsed =
    let
        camPos =
            position cameraRig

        target =
            add pPos <| scale 2 Geometry.up

        squaredDistance =
            (norm <| subtract target camPos) ^ 2.2

        followPlayerVelocity =
            scale (elapsed * cameraRig.followSpeed * squaredDistance) <| normalise <| subtract target camPos

        newPosition =
            add camPos followPlayerVelocity

        -- Clamped values
        newPositionX =
            clamp newPosition.x ((worldSize.x * 0.5) - (cameraRig.size.x * 0.5))

        newPositionY =
            clamp newPosition.y ((worldSize.y * 0.5) - (cameraRig.size.y * 0.2))
    in
    if cameraRig.behaviour == Statonary then
        { cameraRig | camera = cameraRig.camera }

    else
        -- Animate camera to follow player. Is it possible to if/else inside let/in? To avoid unissecary calculations if camera is stationary
        { cameraRig
            | camera = Cam.moveTo ( newPositionX, newPositionY ) cameraRig.camera
            , target = target
        }


{-| Renders the camera target and current position
-}
renderDebugVisuals : CameraRig -> List Renderable
renderDebugVisuals cameraRig =
    let
        markerSize =
            Vector 0.15 0.15

        cameraPositionMarkerPosition =
            subtract (toVector <| Cam.getPosition cameraRig.camera) <| scale 0.5 markerSize

        cameraTargetMarkerPosition =
            subtract cameraRig.target <| scale 0.5 markerSize

        cameraPositionMarker =
            Render.shape circle { color = Color.blue, position = toTuple cameraPositionMarkerPosition, size = toTuple markerSize }

        targetMarker =
            Render.shape circle { color = Color.green, position = toTuple cameraTargetMarkerPosition, size = toTuple markerSize }
    in
    [ targetMarker
    , cameraPositionMarker
    ]
