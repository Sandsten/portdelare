module View exposing (view)

-- Temporary import, stolen from button example
import Html exposing (Html, div, text)

import Model exposing (GameState(..), Model)
import Messages exposing (Msg)

view : Model -> Html Msg
view model =
  div []
    [ div [] [ text ("Hej") ]
    ]
-- Mogee's view:
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