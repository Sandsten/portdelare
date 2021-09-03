module Messages exposing (Msg(..))


type Msg
    = Resize Int Int
    | KeyChange Bool Int
    | Animate Float