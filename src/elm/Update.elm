module Update exposing(update)

import Model exposing (..)
import Msg exposing (..)
import Port exposing(..)
import MyJson exposing(..)

import Json.Decode


-- UPDATE
newMessage : ChatMessage -> Model -> Model
newMessage chatMsg model =
  { model | logs = List.append model.logs [ ChatLog chatMsg ] }


appendLog : MessageLog -> Model -> Model
appendLog log model =
  { model | logs = List.append model.logs [ log ] }


onSendLogin : Model -> (Model, Cmd Msg)
onSendLogin model =
  case model.username of
    Nothing ->
      ({ model | systemMessage = Just "Input usrname"}, Cmd.none)
    Just name ->
      if name /= "" then
        let
          cmd =
            (User model.userID name)
            |> encodeUser
            |> sendLogin
        in
        ({ model | currentScene = Logging}, cmd)
      else
        ({ model | systemMessage = Just "Input usrname"}, Cmd.none)


onSendChat : Model -> (Model, Cmd Msg)
onSendChat model =
  case model.username of
    (Just username) ->
      let
        cmd =
          (ChatMessage (User model.userID username) model.draft)
          |> encodeChatMessage
          |> sendMessage
      in
      ( { model | draft = "" }, cmd)
    _ ->
      ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    SetID userID ->
      ( { model | userID = userID }, Cmd.none )
    ChangeUserName username ->
      ( { model | username = Just username }, Cmd.none )

    SendLogin ->
      onSendLogin model

    NewLogin json ->
      let
        r = Json.Decode.decodeString userDecoder json
      in
      case r of
        Ok user ->
          case model.currentScene of
            Chat ->
              (model |> appendLog (LoginLog user), Cmd.none)
            
            Logging ->
              if isUserSelf user model then
                ({ model
                | currentScene = Chat
                }, Cmd.none)
              else
                ({ model
                | currentScene = Login
                , username = Nothing
                , systemMessage = Just <| "Failed to login."
                }, Cmd.none)
            
            _ -> (model, Cmd.none)
        Err _ ->
          ({model
          | systemMessage = Just <| "Received incorrect format login: " ++ json
          }, Cmd.none)
      

    ReceivedChat json ->
      let
        r = Json.Decode.decodeString chatMessageDecoder json
      in
      case r of
        Ok newChat ->
          ( newMessage newChat model, Cmd.none)
        Err _ ->
          ({model
          | systemMessage = Just <| "Received incorrect format message: " ++ json
          }, Cmd.none)

    ChangeDraft draft ->
      ( { model | draft = draft }, Cmd.none )

    SendChat ->
      onSendChat model

    KeyPress key ->
      case key of 
        13 ->
          case model.currentScene of
            Login ->
              onSendLogin model
            Chat ->
              onSendChat model
            Logging ->
              ( model, Cmd.none )
        _ ->
          (model, Cmd.none)