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


appendLog log model =
  { model | logs = List.append model.logs [ log ] }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    SetID userID ->
      ( { model | userID = userID }, Cmd.none )
    ChangeUserName username ->
      ( { model | username = Just username }, Cmd.none )

    SendLogin ->
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

    NewLogin json ->
      let
        r = Json.Decode.decodeString userDecoder json
      in
      case r of
        Ok user ->
          let newModel = appendLog (LoginLog user) model
          in
          case model.currentScene of
            Chat ->
              ( newModel, Cmd.none )
            
            Logging ->
              if isUserSelf user newModel then
                ({ newModel
                | currentScene = Chat
                }, Cmd.none )
              else
                ({ newModel
                | currentScene = Login
                , username = Nothing
                }, Cmd.none )
            
            _ -> ( newModel, Cmd.none )
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