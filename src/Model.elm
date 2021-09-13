module Model exposing
    ( GameState(..)
    , Model
    , initial
    , update
    , playerPos
    )

import Keys as Keys exposing (Keys, codes)
import Messages exposing (Msg(..))
import Player exposing (..)
import Geometry exposing (Vector)



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
    }


initial : Model
initial =
    { sound = True
    , state = Playing
    , keys = Keys.initial
    , player = Player.initial
    }



-- Main game loop: takes an action (Msg) and updates the model accordingly


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Resize w h ->
            ( model, Cmd.none )

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
            ( updatePos model, Cmd.none )

        Paused ->
            ( model, Cmd.none )


animateKeys : Float -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
animateKeys elapsed ( model, cmd ) =
    ( { model | keys = Keys.animate elapsed model.keys }
    , cmd
    )


updatePos : Model -> Model
updatePos model =
    let
        { x, y } = Keys.directions model.keys
        player = model.player
            
    in
    { model
      | player = { player
        | pos = Vector (model.player.pos.x + x) (model.player.pos.y + y)
      }
    }

playerPos : Model -> Vector
playerPos m = m.player.pos