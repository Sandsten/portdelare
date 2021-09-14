module Messages exposing (Msg(..))

import Game.Resources as Resources exposing (Resources)


type Msg
    = Resize Int Int
    | KeyChange Bool Int
    | Animate Float
    | Resources Resources.Msg
