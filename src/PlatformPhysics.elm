module PlatformPhysics exposing (..)


import Geometry exposing (..)
import Maybe exposing (withDefault)
import Json.Decode exposing (null)


maxSpeed : Float
maxSpeed =
    0.005


minSpeed : Float
minSpeed =
    0.0005


defaultAcceleration : Float
defaultAcceleration =
    0.00005


dragCoeff : Float
dragCoeff =
    20*0.025

gravity : Float
gravity =
    0.000025

jumpAcc : Float
jumpAcc =
    0.002

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

        cappedXSpeed =
            min (abs naiveVelocity.x) maxSpeed
        cappedYSpeed =
            min (abs naiveVelocity.y) (2 * maxSpeed)

        cappedVelocity =
            { naiveVelocity
            | x = if naiveVelocity.x == 0 then 0 else
                naiveVelocity.x * cappedXSpeed / (abs naiveVelocity.x)
            , y = if naiveVelocity.y == 0 then 0 else
                naiveVelocity.y * cappedYSpeed / (abs naiveVelocity.y)
            }
          
    in
        if hasForce || ((dt * abs acceleration.x) <= abs velocity.x) then
            cappedVelocity
        else
            nullVector

computeAcceleration : Vector -> Vector -> Vector -> Vector -> Vector
computeAcceleration direction velocity pos gameWorldSize =
    let
        drag = scale ((norm velocity)^2 * dragCoeff) <| flip <| normalise { velocity | y = 0 }
    in
        add
            ( scale gravity down )
            ( if isNullVector direction then
                  drag
              else
                  add
                      ( scale defaultAcceleration <| normalise { direction | y = 0 } )
                      ( if (pos.y == 1/4 - gameWorldSize.y/2) && not (direction.y == 0) then
                           scale jumpAcc up
                        else
                           nullVector
                      )
            )
        