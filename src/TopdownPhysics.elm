module TopdownPhysics exposing (..)

import Geometry exposing (..)


maxSpeed : Float
maxSpeed =
    0.005


defaultAcceleration : Float
defaultAcceleration =
    0.00005


defaultDrag : Float
defaultDrag =
    0.025


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
    if hasForce || (dt * norm acceleration >= norm velocity)
    then cappedVelocity
    else nullVector

computeAcceleration : Vector -> Vector -> Vector
computeAcceleration direction velocity =
    if isNullVector direction then
        scale ((norm velocity) * defaultDrag) <| flip <| normalise velocity
    else
        scale defaultAcceleration direction