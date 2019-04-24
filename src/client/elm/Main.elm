module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http

import Port exposing(..)

-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


subscriptions : Model -> Sub Msg
subscriptions model =
  receiveMessage ReceivedChat


-- MODEL

type alias Username = String

type alias Chat = String

type alias Model =
  { messages : List (Username, Chat)
  , draft : Chat
  , username : Maybe Username
  , isUsernameDecided : Bool
  }


init : () -> ( Model, Cmd Msg )
init _ =
  ( { messages = []
    , draft = ""
    , username = Nothing
    , isUsernameDecided = False
    }
  , Cmd.none
  )



-- UPDATE


type Msg
  = ChangeUsername Username
  | SendUsername
  | ReceivedChat Chat
  | ChangeDraft Chat
  | SendChat


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    ChangeUsername username ->
      ( { model | username = Just username }, Cmd.none )

    SendUsername ->
      if model.username /= Nothing && model.username /= Just "" then
        ( { model | isUsernameDecided = True }, Cmd.none )
      else
        ( model, Cmd.none )

    ReceivedChat newChat ->
      case newChat |> String.split ";" of
        name::chatlist ->
          let chat = String.concat chatlist in
          ( { model | messages = List.append model.messages [ (name, chat ) ] }, Cmd.none )
        _ ->
          ( model, Cmd.none )

    ChangeDraft draft ->
      ( { model | draft = draft }, Cmd.none )

    SendChat ->
      case model.username of
        Nothing ->
          ( { model | isUsernameDecided = False }, Cmd.none )
        Just username ->
          let
            (name, draft) =
              ( model.username |> Maybe.map (String.replace ";" ":") |> Maybe.withDefault "Missing"
              , model.draft |> String.replace ";" ":"
              )
          in
          ( { model | draft = "" }
          , sendMessage (name ++ ";" ++ draft)
          )



-- VIEW


view : Model -> Html Msg
view model =
  if model.isUsernameDecided then
    div []
      [ div [ id "head"]
          [ h1 [] [text "Chat"]
          , p [] [ text ("Username:" ++ (model.username |> Maybe.withDefault "Missing")) ]
          ]
      , div []
          [ ul [ id "messages" ]
            (
              model.messages
              |> List.map (\(username, chat) ->
                li []
                  [ div [ id "username" ] [ text username ]
                  , div [ id "chat" ] [ text chat ]
                  ]
              )
            )
          , div [ id "chatform" ]
            [ input [ value model.draft, onInput ChangeDraft ][]
            , button [ onClick SendChat ] [ text "Send" ]
            ]
          ]
      ]
  else
    let username = model.username |> Maybe.withDefault "" in
    div [ id "username-input" ]
      [ p [] [ text "username"]
      , div []
          [ input [ placeholder "Input Username", value username, onInput ChangeUsername ][]
          , button [ onClick SendUsername ] [ text "Send" ]
          ]
      ]
