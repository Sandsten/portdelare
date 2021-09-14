module Geometry exposing (..)


type alias Vector =
    { x : Float, y : Float }


add : Vector -> Vector -> Vector
add v w =
    Vector (v.x + w.x) (v.y + w.y)


subtract : Vector -> Vector -> Vector
subtract v w =
    add v <| flip w


scale : Float -> Vector -> Vector
scale a v =
    Vector (a * v.x) (a * v.y)


rescale : Float -> Vector -> Vector
rescale a v =
    if isNullVector v then
        v

    else
        scale (a / norm v) v


flip : Vector -> Vector
flip v =
    scale -1 v


norm : Vector -> Float
norm v =
    sqrt (v.x ^ 2 + v.y ^ 2)


normalise : Vector -> Vector
normalise v =
    let
        size =
            norm v
    in
    if size == 0 then
        v

    else
        scale (1 / size) v


nullVector : Vector
nullVector =
    { x = 0, y = 0 }


isNullVector : Vector -> Bool
isNullVector v =
    (v.x == 0) && (v.y == 0)
