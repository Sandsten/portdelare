module Model exposing
    ( GameState(..)
    , Model
    , initial
    , playerPos
    , update
    )

import Browser.Dom exposing (getViewport)
import Geometry exposing (Vector)
import Keys as Keys exposing (Keys, codes)
import Messages exposing (Msg(..))
import Player exposing (..)
import Geometry exposing (..)



-- Our game will likely have other states than these.


type GameState
    = Playing
    | Paused



{--
  Mogee's gamestate, using Components.Menu
  = Paused Menu
  | Playing
  | Dead
  | Initial Menu
-}


type alias Model =
    { sound : Bool -- just an example
    , state : GameState
    , keys : Keys
    , player : Player
    , screenSize : { w : Int, h : Int }
    }


initial : Model
initial =
    { sound = True
    , state = Playing
    , keys = Keys.initial
    , player = Player.initial
    , screenSize = { w = 800, h = 500 } -- Have to get the initial size somehow
    }



-- Main game loop: takes an action (Msg) and updates the model accordingly


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        -- If the user changes the size of their browser window
        Resize w h ->
            ( { model
                | screenSize = { w = w, h = h }
              }
            , Cmd.none
            )

        -- I think this thing is just for reading some boring key commands
        KeyChange pressed keyCode ->
            ( { model
                | keys = Keys.keyChange pressed keyCode model.keys

                -- , padding =
                --     -- resize the vieport with `-` and `=`
                --     case ( pressed, keyCode ) of
                --         ( True, 189 ) ->
                --             model.padding + 1
                --         ( True, 187 ) ->
                --             max 0 (model.padding - 1)
                --         _ ->
                --             model.padding
              }
            , Cmd.none
            )

        Animate elapsed ->
            model
                |> animate elapsed
                |> animateKeys elapsed


animate : Float -> Model -> ( Model, Cmd Msg )
animate elapsed model =
    case model.state of
        Playing ->
            ( { model | player = Player.animate elapsed (Keys.directions model.keys) model.player }
            , Cmd.none
            )

        Paused ->
            ( model, Cmd.none )


animateKeys : Float -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
animateKeys elapsed ( model, cmd ) =
    ( { model | keys = Keys.animate elapsed model.keys }
    , cmd
    )


-- updatePos : Model -> Model
-- updatePos model =
--     let
--         dir = Keys.directions model.keys
--         player = model.player
            
--     in
--     { model
--       | player = { player
--         | pos = add model.player.pos dir
--       }
--     }

-- Return the position of the player, without needing to expose inner workings
playerPos : Model -> Vector
playerPos m =
    m.player.pos
