module World exposing (..)

import Geometry exposing (..)

type alias World = 
  { size : Vector
  }

initial : World
initial =
  { size = Vector 16 8
  }