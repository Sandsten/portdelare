module Player exposing (..)

import Debug exposing (..)
import Geometry exposing (..)
import Html exposing (p)


type alias Player =
    { pos : Vector
    , velocity : Vector
    , acceleration : Vector
    , alive : Bool
    }


maxSpeed : Float
maxSpeed =
    0.005


defaultAcceleration : Float
defaultAcceleration =
    0.00005


defaultDrag : Float
defaultDrag =
    0.025


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
        newVelocity =
            computeVelocity dt (not <| isNullVector direction) p.acceleration p.velocity

        newSpeed =
            norm newVelocity

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
        , velocity = newVelocity
        , acceleration =
            if isNullVector direction then
                scale (newSpeed * defaultDrag) <| flip <| normalise p.velocity

            else
                scale defaultAcceleration direction
    }



-- First, we bound the speed by maxSpeed.
-- Then, we set the velocity to zero if:
--  * there is no force acting on the object, and
--  * the speed change is larger than the speed.


computeVelocity dt hasForce acceleration velocity =
    let
        naiveVelocity =
            add velocity (scale dt acceleration)

        naiveSpeed =
            norm naiveVelocity

        cappedSpeed =
            min naiveSpeed maxSpeed

        cappedVelocity =
            rescale cappedSpeed naiveVelocity
    in
    if hasForce || (dt * norm acceleration >= norm velocity) then
        cappedVelocity

    else
        nullVector
