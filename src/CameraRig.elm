module CameraRig exposing (..)

-- The idea is to have a camera rig with an attached camera.
-- All logic for how the camera can move etc should be determined by the camera rig.
-- More types could be defined such as follow speed, size etc..

import Game.TwoD.Camera as Cam exposing (..)
import Geometry exposing (..)


type CameraBehaviour
    = FollowPlayer
    | Statonary


type alias CameraRig =
    { camera : Cam.Camera
    , position : Vector
    , size : Vector
    , followSpeed : Float
    , behaviour : CameraBehaviour
    , target : Vector
    , followTargetVelocity : Vector
    , debugVisuals : Bool
    }


initial : Vector -> CameraRig
initial size =
    { camera = Cam.fixedArea (size.x * size.y) ( 0, 0 )
    , position = Vector 0 0
    , size = size
    , followSpeed = 0.001
    , behaviour = FollowPlayer
    , target = Vector 0 0
    , followTargetVelocity = Vector 0 0
    , debugVisuals = True
    }


getPosition : CameraRig -> Vector
getPosition cameraRig =
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
            getPosition cameraRig

        target =
            add pPos <| scale 2 Geometry.up

        squaredDistance =
            (norm <| subtract target camPos) ^ 2.2

        followTargetVelocity =
            scale (elapsed * cameraRig.followSpeed * squaredDistance) <| normalise <| subtract target camPos

        newPosition =
            add camPos followTargetVelocity

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
            , position = camPos
            , target = target
            , followTargetVelocity = followTargetVelocity
        }
