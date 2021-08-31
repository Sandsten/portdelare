module ClockExample exposing(..)

import Browser
import Html exposing (..)
import Task
import Time
import Json.Decode exposing (bool)
import Debug exposing (log)
import Html.Events exposing (onClick)
import Svg exposing(..)
import Svg.Attributes exposing(..)
import String exposing (toInt)
import Html.Attributes exposing (style)


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
    hour   = Time.toHour   model.zone model.time
    minute = Time.toMinute model.zone model.time
    second = Time.toSecond model.zone model.time
  in
  div []
  [ 
    svg 
    [ width "100vh"
    , height "100vh"
    , viewBox "0 0 500 500"
    , Svg.Attributes.style "margin-right: auto; margin-left: auto; display: block"
    ]
    [ circle
      [ cx "250"
      , cy "250"
      , r  "240"
      , fill "skyblue"
      ]
      []
    , viewHourHand hour minute
    , viewMinuteHand minute
    , viewSecondHand second
      -- How do we loop this???
    , viewHour 1
    , viewHour 2
    , viewHour 3
    , viewHour 4
    , viewHour 5
    , viewHour 6
    , viewHour 7
    , viewHour 8
    , viewHour 9
    , viewHour 10
    , viewHour 11
    , viewHour 12
    , circle
      [ cx "250"
      , cy "250"
      , r  "5"
      , fill "black"
      ]
      []
    ]
  ]

viewHour : Int -> Svg Msg
viewHour hour = 
  let
    rotation = toFloat hour * (360/12) - 90
    r1 = 190
    r2 = 235
    origin = 250
    p1x = origin + (cos (degrees rotation) * r1)
    p1y = origin + (sin (degrees rotation) * r1)
    p2x = origin + (cos (degrees rotation) * r2)
    p2y = origin + (sin (degrees rotation) * r2)
  in
  line
  [ x1 (String.fromFloat p1x)
  , y1 (String.fromFloat p1y)
  , x2 (String.fromFloat p2x)
  , y2 (String.fromFloat p2y)
  , stroke "black"
  , strokeWidth "10"
  ]
  [] 

viewSecondHand : Int -> Svg Msg
viewSecondHand second =
  let
    rotation = toFloat second * (360/60) - 90
    r1 = 0
    r2 = 180
    origin = 250
    p1x = origin + (cos (degrees rotation) * r1)
    p1y = origin + (sin (degrees rotation) * r1)
    p2x = origin + (cos (degrees rotation) * r2)
    p2y = origin + (sin (degrees rotation) * r2)
  in
  line
  [ x1 (String.fromFloat p1x)
  , y1 (String.fromFloat p1y)
  , x2 (String.fromFloat p2x)
  , y2 (String.fromFloat p2y)
  , stroke "black"
  , strokeWidth "2"
  ]
  [] 

viewMinuteHand : Int -> Svg Msg
viewMinuteHand minute =
  let
    rotation = toFloat minute * (360/60) - 90
    r1 = 0
    r2 = 180
    origin = 250
    p1x = origin + (cos (degrees rotation) * r1)
    p1y = origin + (sin (degrees rotation) * r1)
    p2x = origin + (cos (degrees rotation) * r2)
    p2y = origin + (sin (degrees rotation) * r2)
  in
  line
  [ x1 (String.fromFloat p1x)
  , y1 (String.fromFloat p1y)
  , x2 (String.fromFloat p2x)
  , y2 (String.fromFloat p2y)
  , stroke "black"
  , strokeWidth "5"
  ]
  [] 

viewHourHand : Int -> Int -> Svg Msg
viewHourHand hour minute =
  let
    hourAnalogue = (modBy 12 hour)
    extraRotation = (toFloat minute / 60) * (360/12) -- Hour hand moves slowly between hours based on minutes
    rotation = toFloat hourAnalogue * (360/12) - 90 + extraRotation
    r1 = 0
    r2 = 90
    origin = 250
    p1x = origin + (cos (degrees rotation) * r1)
    p1y = origin + (sin (degrees rotation) * r1)
    p2x = origin + (cos (degrees rotation) * r2)
    p2y = origin + (sin (degrees rotation) * r2)
  in
  line
  [ x1 (String.fromFloat p1x)
  , y1 (String.fromFloat p1y)
  , x2 (String.fromFloat p2x)
  , y2 (String.fromFloat p2y)
  , stroke "black"
  , strokeWidth "5"
  ]
  [] 