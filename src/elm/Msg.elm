module Msg exposing(..)

import Model exposing(..)

type Msg
  = SetID ID
  | ChangeUserName UserName
  | SendLogin
  | NewLogin UserName
  | ReceivedChat String
  | ChangeDraft Chat
  | SendChat