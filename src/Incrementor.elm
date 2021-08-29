module Incrementor exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--


import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)



-- MAIN

-- main value describes what gets shown on the screen
-- view will show everything on the screen
-- user input will be fed to the update function
main =
  Browser.sandbox { init = init, update = update, view = view }

-- MODEL
type alias Model = Int
init : Model
init =
  0

-- UPDATE

type Msg
  = Increment Int
  | Decrement
  | Reset

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ammount->
      model + ammount

    Decrement ->
      model - 1

    Reset ->
      0

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model) ]
    , button [ onClick (Increment 1)] [ text "+" ]
    , button [ onClick (Increment 10)] [ text "+10" ]
    , button [ onClick Reset ] [ text "Reset" ]
    ]