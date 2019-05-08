module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, onInput)
import Json.Decode as Json

import Model exposing(..)
import Msg exposing(..)


-- onKeyPressはInt（押されたキー）とMsg（Enter）を引数にとりMsg（Enter）を発行
onKeyPress : (Int -> Msg) -> Attribute Msg
onKeyPress tagger =
  Html.Events.on "keypress" (Json.map tagger Html.Events.keyCode)


loginView : Model -> Html Msg
loginView model =
  let
    username = model.username |> Maybe.withDefault ""
  in
  div []
    [ div [ class "username-input" ]
        [ p [] [ text "username"]
        , div []
          [ input
              [ placeholder "Input UserName"
              , value username
              , onInput ChangeUserName
              , onKeyPress SendLoginKey ][]
          , button [ onClick SendLogin ] [ text "Send" ]
          ]
        ]
    ]



loggingView : Model -> Html Msg
loggingView model =
  div [] [ text "Logging" ]



getScreenName : User -> String
getScreenName user =
      user.name
      -- ++ "#" ++ (user.userID |> String.fromInt)


chatView : Model -> Html Msg
chatView model =
  let
    screenName =
      let
        name = model.username |> Maybe.withDefault "Missing"
      in
      getScreenName <| User model.userID name
  in
  div []
    [ div [ class "head"]
        [ p [] [ text ("You: " ++ screenName) ]
        ]
    , div []
      [ ul [ class "messages" ]
        (
          model.logs
          |> List.map (\log ->
            li []
              [ case log of
                  ChatLog chatMsg ->
                    let user = chatMsg.user
                    in
                    let
                      msgId =
                        if isUserSelf user model
                        then "self"
                        else "other"
                    in
                    div [class "chat", class msgId]
                      [ div [ class "block" ]
                        [ div [ class "username" ]
                          [ text user.name
                          ]
                        ]
                      , div [ class "block" ]
                        [ div [ class "message" ]
                            [ text chatMsg.chat
                            ]
                        ]
                      ]
                  LoginLog user ->
                    div [class "login" ]
                      [ div [ class "newlogin" ] [ text "NewLogin: " ]
                      , div [ class "block" ]
                        [ div [ class "username" ]
                          [ text <| getScreenName user
                          ]
                        ]
                      ]
              ]
          )
        )
      , div [ class "chatform" ]
        [ input [ value model.draft, onInput ChangeDraft, onKeyPress SendChatKey ][]
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
        , div [ class "system-message"]
          [ div [ class "system" ]
            [  text <| "System Message: " ]
          , div [ class "message" ] [ text str ]
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