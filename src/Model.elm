module Model exposing
  ( GameState(..)
  , Model
  , initial
  , update
  )

import Messages exposing (Msg(..))

-- Our game will likely have other states than these.
type GameState
  = Playing
  | Paused
-- Mogee's gamestate, using Components.Menu
  -- = Paused Menu
  -- | Playing
  -- | Dead
  -- | Initial Menu

type alias Model = 
  { sound : Bool -- just an example
  , state : GameState
  }
initial : Model
initial = 
  { sound = True
  , state = Playing
  }

-- Main game loop: takes an action (Msg) and updates the model accordingly
update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
  ( model, Cmd.none )
-- Should be a big case-of on the `action` for all the possible messages

-- Helper function to be called from `update`
animate : Float -> Model -> ( Model, Cmd Msg )
animate elapsed model =
  ( model, Cmd.none )
-- For now, doesn't do anything. Should take the elapsed time and update the model accordingly
-- Should be a case-of on model.state
-- Mogee also uses other helper functions, we might want to do the same. I just included this one as an example.

-- Etc