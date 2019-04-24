module Update exposing(update)

import Model exposing (..)
import Msg exposing (..)
import Port exposing(..)

-- UPDATE


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