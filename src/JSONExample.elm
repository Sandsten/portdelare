module JSONExample exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)



-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL

{--
  We defines this app to be able to have three different states
  If it's successfull it will have a string to store! Which is the url to our cat gif
--}
type Model
  = Failure
  | Loading
  | Success String


init : () -> (Model, Cmd Msg)
init _ =
  (Loading, getRandomCatGif)



-- UPDATE

{--
  Two types of Messages which can be passed to our elm code
  Either the user wants a new cat gif
  or a cat gif has been recieved from the api call
  (Result Http.Error String) is standard where the last element is the type we want the result to be in the end

  If you call these types as functions from view, they will be handled in the update function accordingly
--}
type Msg
  = MorePlease
  | GotGif (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (Loading, getRandomCatGif)

    GotGif result ->
      case result of
        Ok url ->
          (Success url, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [ text "Random Cats" ]
    , viewGif model
    ]


viewGif : Model -> Html Msg
viewGif model =
  case model of
    Failure ->
      div []
        [ text "I could not load a random cat for some reason. "
        , button [ onClick MorePlease ] [ text "Try Again!" ]
        ]

    Loading ->
      text "Loading..."

    Success url ->
      div []
        {--
          MorePlease is connected to our update type above.
          I think that what's returned as Msg which the update function will handle.
          !!! Kinda confusing that MorePlease called as a function? I don't fully understand that yet
        --}
        [ button [ onClick MorePlease, style "display" "block" ] [ text "More Please!" ]
        , img [ src url ] []
        ]



-- HTTP


getRandomCatGif : Cmd Msg
getRandomCatGif =
  Http.get
    { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
    , expect = Http.expectJson GotGif gifDecoder
    }

-- Many different decoder exist depending on what type of data we are handling
-- Package for handling multiple fields more easily NoRedInk/elm-json-decode-pipeline
gifDecoder : Decoder String -- Decoder and type we want to retun
gifDecoder =
  field "data" (field "image_url" string) -- Specify which field we want to extract