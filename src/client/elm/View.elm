module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, onInput)
-- import Keyboard.Event exposing (KeyboardEvent, decodeKeyboardEvent)
import Json.Decode as Json

import Model exposing(..)
import Msg exposing(..)


-- VIEW
-- onKeyDown : (Int -> msg) -> Attribute msg
-- onKeyDown tagger =
--   on "keydown" <|
--     -- Json.map HandleKeyboardEvent decodeKeyboardEvent
--     Json.map tagger decodeKeyboardEvent

loginView : Model -> Html Msg
loginView model =
  let
    username = model.username |> Maybe.withDefault ""
  in
  div []
    [ div [ class "username-input" ]
        [ p [] [ text "username"]
        , div []
          [ input [ placeholder "Input Username", value username, onInput ChangeUsername ][]
          , button [ onClick SendLogin ] [ text "Send" ]
          ]
        ]
    ]



loggingView : Model -> Html Msg
loggingView model =
  div [] [ text "Logging" ]



chatView : Model -> Html Msg
chatView model =
  div []
    [ div [ class "head"]
        [ p [] [ text ("Username:" ++ (model.username |> Maybe.withDefault "Missing")) ]
        ]
    , div []
      [ ul [ class "messages" ]
        (
          model.messages
          |> List.map (\(username, chat) ->
            let
              msgId = if Just username == model.username then "self" else "other"
            in
            li [ id msgId ]
              [ div [ class "username" ] [ text username ]
              , div [ class "chat" ] [ text chat ]
              ]
          )
        )
      , div [ class "chatform" ]
        [ input [ value model.draft, onInput ChangeDraft ][]
        , button [ onClick SendChat ] [ text "Send" ]
        ]
      ]
    ]

sceneView model =
  case model.currentScene of
    Login -> loginView model
    Logging -> loggingView model
    Chat -> chatView model

headView model =
  let appname = "COJT chat app"
  in
  let scenename = ""
    -- case model.currentScene of
    --   Login -> "Login"
    --   Logging -> "Logging"
    --   Chat -> "Chat"
  in
  let headTitle = appname ++ " / " ++ scenename
  in
  case model.systemMessage of
    Just str ->
      div [ class "application-head"]
        [
          h1 [] [text headTitle]
        , p [ class "system message"]
          [
            text <| "System Message: " ++ str
          ]
        ]
    Nothing ->
      div [ class "application-head"]
        [
          h1 [] [text headTitle]
        ]

view : Model -> Html Msg
view model =
  div []
    [
      headView model
    , sceneView model
    ]