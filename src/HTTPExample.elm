module HTTPExample exposing (..)

import Browser
import Html exposing (Html, text, pre)
import Http

-- MAIN

{--
  use Browser.element when we want to communicate with the rest of the internet
  This is done with the subscription parameter

  subscription - This allows us look at the Model and decide if we want to subscribe to certain information

--}
main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL


type Model
  = Failure
  | Loading
  | Success String


init : () -> (Model, Cmd Msg)
init _ =
  ( Loading
  , Http.get
      { url = "https://elm-lang.org/assets/public-opinion.txt"
      --] GotText is saying what the response should be converted to
      , expect = Http.expectString GotText 
      }
  )



-- UPDATE


type Msg
  = GotText (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotText result ->
      case result of
        Ok fullText ->
          (Success fullText, Cmd.none)

        Err _ ->
          (Failure, Cmd.none) -- Could pattern match the Http.error and proceed accodingly depending on what went wrong. But now we just give up with Cmd.none



-- SUBSCRIPTIONS

-- Right now we aren't subscribing to anything
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  case model of
    Failure ->
      text "I was unable to load your book."

    Loading ->
      text "Loading..."

    Success fullText ->
      pre [] [ text fullText ]