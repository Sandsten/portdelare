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
    , size : Vector
    , followSpeed : Float
    , behaviour : CameraBehaviour
    }


initial : Vector -> CameraRig
initial size =
    { camera = Cam.fixedArea (size.x * size.y) ( 0, 0 )
    , size = size
    , followSpeed = 0.001
    , behaviour = FollowPlayer
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

        -- Adjust where player should be in the camera view (bottom half or center etc)
        target =
            subtract pPos <| scale 1 Geometry.down

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
        { cameraRig | camera = Cam.moveTo ( newPositionX, newPositionY ) cameraRig.camera }
