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
  let
    errorResult = ({ model | systemMessage = Just "Input usrname"}, Cmd.none)
  in
  case model.username of
    Just name ->
      if name /= "" then
        let
          cmd =
            name
            |> sendLogin
        in
        ({ model | currentScene = Logging}, cmd)

      else
        errorResult
    Nothing -> errorResult


onSendChat : Model -> (Model, Cmd Msg)
onSendChat model =
  case (getUser model) of
    Just user ->
      let
        cmd =
          (ChatMessage user model.draft)
          |> encodeChatMessage
          |> sendMessage
      in
      ( { model | draft = "" }, cmd)
    Nothing ->
      ( { initModel
        | systemMessage = Just "Your user data is incorrect"
        }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    ChangeUserName username ->
      ( { model | username = Just username }, Cmd.none )

    SendLogin ->
      onSendLogin model
  
    SendLoginKey key ->
      case key of 
        13 ->
          onSendLogin model
        _ ->
          (model, Cmd.none)

    ReceiveLoginResult result ->
      case result of
        Success id ->
          ({ model
          | userID = Just id
          , currentScene = Chat
          }, Cmd.none)
        Failed e ->
          ({ initModel
          | systemMessage = Just <| "Failed to login." ++ e
          }, Cmd.none)

    NewLogin json ->
      case model.currentScene of
        Chat ->
          let
            r = Json.Decode.decodeString userDecoder json
          in
          case r of
            Ok user ->
                  (model |> appendLog (LoginLog user), Cmd.none)
            
            Err _ ->
              ({model
              | systemMessage = Just <| "Received incorrect format login: " ++ json
              }, Cmd.none)
        _ -> (model, Cmd.none)
      

    ReceivedChat json ->
      case model.currentScene of
        Chat ->
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
        _ ->
          ( model, Cmd.none )

    ChangeDraft draft ->
      ( { model | draft = draft }, Cmd.none )

    SendChat ->
      onSendChat model

    SendChatKey key ->
      case key of 
        13 ->
          onSendChat model
        _ ->
          (model, Cmd.none)