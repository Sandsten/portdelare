module Player exposing (..)

import Debug exposing (..)
import Geometry exposing (..)
import Html exposing (p)
import PlatformPhysics as Physics


type alias Player =
    { pos : Vector
    , velocity : Vector
    , acceleration : Vector
    , alive : Bool
    }



initial : Player
initial =
    { pos = Vector 0 0
    , velocity = Vector 0 0
    , acceleration = Vector 0 0
    , alive = True
    }


animate : Float -> Vector -> Player -> Vector -> Player
animate dt direction p gameWorldSize =
    let
        hasForce =
            not <| isNullVector direction
    in
    { p
        | pos =
            Physics.computePosition dt p.pos p.velocity gameWorldSize
        , velocity =
            Physics.computeVelocity dt hasForce p.acceleration p.velocity
        , acceleration =
            Physics.computeAcceleration direction p.velocity p.pos gameWorldSize
    }



