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


view : Model -> Html Msg
view model =
  if model.isUsernameDecided then
    div []
      [ div [ class "head"]
          [ h1 [] [text "Chat"]
          , p [] [ text ("Username:" ++ (model.username |> Maybe.withDefault "Missing")) ]
          ]
      , div []
          [ ul [ class "messages" ]
            (
              model.messages
              |> List.map (\(username, chat) ->
                let
                  msgId = if Just username == model.username then "self" else "other"
                in
                li []
                  [ div [ class "username", id msgId ] [ text username ]
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
  else
    let username = model.username |> Maybe.withDefault "" in
    div [ class "username-input" ]
      [ p [] [ text "username"]
      , div []
          [ input [ placeholder "Input Username", value username, onInput ChangeUsername ][]
          , button [ onClick SendUsername ] [ text "Send" ]
          ]
      ]
