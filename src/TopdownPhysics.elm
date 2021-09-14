module TopdownPhysics exposing (..)

import Geometry exposing (..)


maxSpeed : Float
maxSpeed =
    0.005


minSpeed : Float
minSpeed =
    0.001

defaultAcceleration : Float
defaultAcceleration =
    0.00005


defaultDrag : Float
defaultDrag =
    120*0.025

computePosition : Float -> Vector -> Vector -> Vector -> Vector
computePosition dt pos velocity gameWorldSize =
    if (norm velocity <= minSpeed) then
        pos
    else
        let 
            newPos =
                add pos (scale dt velocity)

            leftBound =
                -gameWorldSize.x / 2

            rightBound =
                gameWorldSize.x / 2

            upperBound =
                gameWorldSize.y / 2

            lowerBound =
                -gameWorldSize.y / 2
        in
            Vector
                ( if newPos.x <= leftBound + 1 / 4 then
                    leftBound + 1 / 4

                  else if newPos.x >= rightBound - 1 / 4 then
                    rightBound - 1 / 4

                  else
                    newPos.x
                )
                ( if newPos.y <= lowerBound + 1 / 4 then
                    lowerBound + 1 / 4

                  else if newPos.y >= upperBound - 1 / 4 then
                    upperBound - 1 / 4

                  else
                    newPos.y
                )


-- First, we bound the speed by maxSpeed.
-- Then, we set the velocity to zero if:
--  * there is no force acting on the object, and
--  * the speed change is larger than the speed.
computeVelocity : Float -> Bool -> Vector -> Vector -> Vector
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
    if hasForce || (dt * norm acceleration <= norm velocity) then
        cappedVelocity
    else
        nullVector

computeAcceleration : Vector -> Vector -> Vector -> Vector -> Vector
computeAcceleration direction velocity pos gameWorldSize =
    if isNullVector direction then
        scale ((norm velocity)^2 * defaultDrag) <| flip <| normalise velocity
    else
        scale defaultAcceleration direction