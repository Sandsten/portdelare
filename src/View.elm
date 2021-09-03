module View exposing (view)

-- Temporary import, stolen from button example

import Color
import Game.TwoD as Game
import Game.TwoD.Camera as Camera exposing (Camera)
import Game.TwoD.Render as Render exposing (Renderable, circle, rectangle)
import Html exposing (Html, div, text)
import Messages exposing (Msg)
import Model exposing (GameState(..), Model)


view : Model -> Html Msg
view model =
    Game.renderCentered { time = 0, camera = Camera.fixedHeight 7 ( 0, 1.5 ), size = ( 800, 600 ) }
        [ viewPlayer model.pos.x model.pos.y
        ]


viewPlayer : Float -> Float -> Renderable
viewPlayer x y =
    let
        playerColor =
            Color.green

        playerPosition =
            ( x, y )
    in
    Render.shape rectangle { color = playerColor, position = playerPosition, size = ( 10, 10 ) }



-- Mogee's view:1
-- let
--       ( w, h ) =
--           model.size
--       size =
--           max 1 (min w h // 64 - model.padding) * 64
--   in
--   WebGL.toHtmlWith
--       [ WebGL.depth 1
--       , WebGL.stencil 0
--       , WebGL.clearColor (22 / 255) (17 / 255) (22 / 255) 0
--       ]
--       [ width size
--       , height size
--       , style "display" "block"
--       , style "position" "absolute"
--       , style "top" "50%"
--       , style "left" "50%"
--       , style "margin-top" (String.fromInt (-size // 2) ++ "px")
--       , style "margin-left" (String.fromInt (-size // 2) ++ "px")
--       , style "image-rendering" "optimizeSpeed"
--       , style "image-rendering" "-moz-crisp-edges"
--       , style "image-rendering" "-webkit-optimize-contrast"
--       , style "image-rendering" "crisp-edges"
--       , style "image-rendering" "pixelated"
--       , style "-ms-interpolation-mode" "nearest-neighbor"
--       ]
--       (Maybe.map2 (render model)
--           model.font
--           model.sprite
--           |> Maybe.withDefault []
--       )
