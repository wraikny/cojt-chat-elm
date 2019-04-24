module Model exposing(Model, init)

import Msg exposing(..)

-- MODEL

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