module CameraRig exposing (..)

-- The idea is to have a camera rig with an attached camera.
-- All logic for how the camera can move etc should be determined by the camera rig.
-- More types could be defined such as follow speed, size etc..

import Game.TwoD.Camera as Cam exposing (Camera)
import Geometry exposing (..)


type CameraBehaviour
    = FollowPlayer
    | Statonary


type alias CameraRig =
    { camera : Cam.Camera
    , followSpeed : Float
    , behaviour : CameraBehaviour
    }


initial : Vector -> CameraRig
initial size =
    { camera = Cam.fixedArea (size.x * size.y) ( 0, 0 )
    , followSpeed = 0.0
    , behaviour = Statonary
    }


move : CameraRig -> Vector -> Vector -> Float -> CameraRig
move cameraRig playerPos worldSize elapsed =
    let
        -- TODO: Make camera follow player relative to player speed and maybe distance to player as well?
        ( newCameraPosX, newCameraPosY ) =
            Cam.getPosition cameraRig.camera
    in
    if cameraRig.behaviour == Statonary then
        { cameraRig | camera = Cam.moveTo ( newCameraPosX, newCameraPosY ) cameraRig.camera }

    else
        -- Animate camera to follow player. Is it possible to if/else inside let/in? To avoid unissecary calculations if camera is stationary
        { cameraRig | camera = Cam.moveTo ( newCameraPosX, newCameraPosY ) cameraRig.camera }
