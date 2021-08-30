module ClockExample exposing(..)

import Browser
import Html exposing (..)
import Task
import Time
import Json.Decode exposing (bool)
import Debug exposing (log)
import Html.Events exposing (onClick)



-- MAIN


main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { zone : Time.Zone
  , time : Time.Posix
  , paused : Bool
  }


init : () -> (Model, Cmd Msg)
init _ =
  ( Model Time.utc (Time.millisToPosix 0) False -- Initial state of model 
  , Task.perform AdjustTimeZone Time.here
  )



-- UPDATE


type Msg
  = Tick Time.Posix
  | AdjustTimeZone Time.Zone
  | TogglePause



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ( { model | time = newTime }
      , Cmd.none
      )

    AdjustTimeZone newZone ->
      ( { model | zone = newZone }
      , Cmd.none
      )
    
    TogglePause -> 
      ( { model | paused = log "Is clock paused? " (not model.paused)} -- Toggle the boolean value. And log it to console while we're at it!
      , Cmd.none
      )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  if model.paused then
    Sub.none -- If we want to pause the clock, tell elm that there are no subsciptions!
  else
    Time.every 1000 Tick


-- VIEW


view : Model -> Html Msg
view model =
  let
    hour   = String.fromInt (Time.toHour   model.zone model.time)
    minute = String.fromInt (Time.toMinute model.zone model.time)
    second = String.fromInt (Time.toSecond model.zone model.time)
  in
  div []
  [
    h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
  , button [onClick TogglePause] [text "Pause"]
  ]