module Update exposing(update)

import Model exposing (..)
import Msg exposing (..)
import Port exposing(..)


-- UPDATE
newMessage str model =
  case str |> String.split ";" of
    name::chatlist ->
      let chat = String.concat chatlist in
      { model | messages = List.append model.messages [ (name, chat ) ] }
    _ ->
      model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    ChangeUsername username ->
      ( { model | username = Just username }, Cmd.none )

    SendLogin ->
      case model.username of
        Nothing ->
          ({ model | systemMessage = Just "Input usrname"}, Cmd.none)
        Just name ->
          if name /= "" then
            ({ model | currentScene = Chat}, sendLogin name)
          else
            ({ model | systemMessage = Just "Input usrname"}, Cmd.none)

    NewLogin username ->
      case model.currentScene of
        Chat ->
          ( newMessage (username ++ "Login!") model, Cmd.none)
        
        _ -> (model, Cmd.none)

    ReceivedChat newChat ->
      ( newMessage newChat model, Cmd.none)

    ChangeDraft draft ->
      ( { model | draft = draft }, Cmd.none )

    SendChat ->
      case model.username of
        Nothing ->
          ( model, Cmd.none )
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