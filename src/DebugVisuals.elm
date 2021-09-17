module DebugVisuals exposing (renderDebugVisuals)

import CameraRig exposing (..)
import Game.TwoD.Render exposing (Renderable)
import Model exposing (Model)


{-| Returns all debug visuals
-}
renderDebugVisuals : Model -> List Renderable
renderDebugVisuals model =
    List.concat
        [ CameraRig.renderDebugVisuals model.cameraRig
        ]
