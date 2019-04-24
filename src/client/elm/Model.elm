module Model exposing(..)

import Msg exposing(..)

-- MODEL
type Scene
  = Login
  | Logging
  | Chat


type alias Model =
  { messages : List (Username, Chat)
  , draft : Chat
  , username : Maybe Username
  , currentScene : Scene
  , systemMessage : Maybe String
  }


init : () -> ( Model, Cmd Msg )
init _ =
  ( { messages = []
    , draft = ""
    , username = Nothing
    , currentScene = Login
    , systemMessage = Nothing
    }
  , Cmd.none
  )