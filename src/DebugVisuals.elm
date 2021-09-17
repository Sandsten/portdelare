module DebugVisuals exposing (renderDebugVisuals)

import CameraRig exposing (..)
import Color
import Game.TwoD.Render as Render exposing (Renderable, circle)
import Geometry exposing (..)
import Model exposing (Model)


{-| Returns all debug visuals
-}
renderDebugVisuals : Model -> List Renderable
renderDebugVisuals model =
    List.concat
        [ renderDebugCameraRigVisuals model.cameraRig
        ]


{-| Renders the camera target and current position
-}
renderDebugCameraRigVisuals : CameraRig -> List Renderable
renderDebugCameraRigVisuals cameraRig =
    let
        markerSize =
            Vector 0.15 0.15

        cameraPositionMarkerPosition =
            subtract cameraRig.position <| scale 0.5 markerSize

        cameraTargetMarkerPosition =
            subtract cameraRig.target <| scale 0.5 markerSize

        cameraPositionMarker =
            Render.shape circle { color = Color.blue, position = toTuple cameraPositionMarkerPosition, size = toTuple markerSize }

        targetMarker =
            Render.shape circle { color = Color.green, position = toTuple cameraTargetMarkerPosition, size = toTuple markerSize }
    in
    if cameraRig.debugVisuals then
        [ targetMarker
        , cameraPositionMarker
        ]

    else
        []
