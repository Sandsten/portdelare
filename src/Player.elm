module Player exposing (..)

import Debug exposing (..)
import Geometry exposing (..)
import Html exposing (p)
import TopdownPhysics as Physics


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

-- TODO: move "computePosition to Physics"

animate : Float -> Vector -> Player -> Vector -> Player
animate dt direction p gameWorldSize =
    let
        newPos =
            add p.pos (scale dt p.velocity)

        leftBound =
            -gameWorldSize.x / 2

        rightBound =
            gameWorldSize.x / 2

        upperBound =
            gameWorldSize.y / 2

        lowerBound =
            -gameWorldSize.y / 2

        hasForce =
            not <| isNullVector direction
    in
    { p
        | pos =
            Vector
                (if newPos.x <= leftBound + 1 / 4 then
                    leftBound + 1 / 4

                 else if newPos.x >= rightBound - 1 / 4 then
                    rightBound - 1 / 4

                 else
                    newPos.x
                )
                (if newPos.y <= lowerBound + 1 / 4 then
                    lowerBound + 1 / 4

                 else if newPos.y >= upperBound - 1 / 4 then
                    upperBound - 1 / 4

                 else
                    newPos.y
                )
        , velocity =
            Physics.computeVelocity dt hasForce p.acceleration p.velocity
        , acceleration =
            Physics.computeAcceleration direction p.velocity
    }



