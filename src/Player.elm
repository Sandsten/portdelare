module Player exposing (..)

import Geometry exposing (Vector)

type alias Player =
  { pos : Vector
  , velocity : Vector
  , alive : Bool
  }

initial : Player
initial =
  { pos = Vector 0 0
  , velocity = Vector 0 0
  , alive = True
  }