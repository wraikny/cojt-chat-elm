module Msg exposing(..)

import Model exposing(..)

type Msg
  = SetID ID
  | ChangeUserName UserName
  | SendLogin
  | SendLoginKey Int
  | NewLogin UserName
  | ReceivedChat String
  | ChangeDraft Chat
  | SendChat
  | SendChatKey Int