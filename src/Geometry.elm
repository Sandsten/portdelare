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
    sqrt <| dotProd v v


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


down : Vector
down =
    Vector 0 -1


up : Vector
up =
    Vector 0 1


left : Vector
left =
    Vector -1 0


right : Vector
right =
    Vector 1 0


dotProd : Vector -> Vector -> Float
dotProd v w =
    v.x * w.x + v.y * w.y


cosAngle : Vector -> Vector -> Float
cosAngle v w =
    if isNullVector v || isNullVector w then
        0

    else
        dotProd v w / (norm v * norm w)


toTuple : Vector -> ( Float, Float )
toTuple v =
    ( v.x, v.y )


toVector : ( Float, Float ) -> Vector
toVector ( x, y ) =
    Vector x y
