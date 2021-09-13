module Keys exposing
    ( Keys
    , animate
    , codes
    , directions
    , initial
    , keyChange
    )

import Dict exposing (Dict)
import Geometry exposing (..)


type alias Keys =
    Dict Int Float


initial : Keys
initial =
    Dict.empty


codes :
    { down : Int
    , enter : Int
    , left : Int
    , right : Int
    , space : Int
    , up : Int
    , q : Int
    , escape : Int
    }
codes =
    { enter = 13
    , space = 32
    , escape = 27
    , q = 81
    , left = 37
    , right = 39
    , up = 38
    , down = 40
    }


keyChange : Bool -> Int -> Keys -> Keys
keyChange on code keys =
    if on then
        if Dict.member code keys then
            keys

        else
            Dict.insert code 0 keys

    else
        Dict.remove code keys


animate : Float -> Keys -> Keys
animate elapsed =
    Dict.map (\_ -> (+) elapsed)


down : Int -> Keys -> Bool
down =
    Dict.member


-- Returns a normalised direction (depending on which arrow keys are pressed)
directions : Keys -> Vector 
directions keys =
    let
        direction a b =
            case ( a, b ) of
                ( True, False ) ->
                    -1

                ( False, True ) ->
                    1

                _ ->
                    0
    in
    normalise ( Vector
        (direction (down codes.left keys) (down codes.right keys))
        (direction (down codes.down keys) (down codes.up keys))
    )