module Player exposing (..)

import Geometry exposing (..)
import Html exposing (p)
import Debug exposing (..)

type alias Player =
  { pos : Vector
  , velocity : Vector
  , acceleration : Vector
  , alive : Bool
  }

maxSpeed : Float
maxSpeed = 0.01

defaultAcceleration : Float
defaultAcceleration = 0.0001

defaultDrag : Float
defaultDrag = 0.001


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
    
  in
    { p
    | pos = add p.pos (scale dt p.velocity)
    , velocity = if (newSpeed <= maxSpeed)
                 then newVelocity
                 else scale (maxSpeed/newSpeed) newVelocity
    , acceleration =
      if isNullVector direction then
        scale (newSpeed * defaultDrag) <| flip <| normalise p.velocity
      else
        scale defaultAcceleration direction
    }