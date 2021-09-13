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
    0.018


initial : Player
initial =
    { pos = Vector 0 0
    , velocity = Vector 0 0
    , acceleration = Vector 0 0
    , alive = True
    }


animate : Float -> Vector -> Player -> Player
animate dt direction p =
  let
    newVelocity = add p.velocity (scale dt p.acceleration)
    newSpeed = norm newVelocity
    newPos = add p.pos (scale dt p.velocity)
    
  in
    { p
    | pos = Vector
      ( if newPos.x <= -4 + 1/4 then -4 + 1/4 else
        if newPos.x >= 4 - 1/4 then 4 - 1/4 else newPos.x
      )
      ( newPos.y )
    , velocity = if (newSpeed <= maxSpeed)
                 then newVelocity
                 else scale (maxSpeed/newSpeed) newVelocity
    , acceleration =
      if isNullVector direction then
        scale (newSpeed * defaultDrag) <| flip <| normalise p.velocity
      else
        scale defaultAcceleration direction
    }
