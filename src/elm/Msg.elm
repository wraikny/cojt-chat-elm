module Msg exposing(..)

import Model exposing(..)

type LoginResult
  = Success Int
  | Failed String


type Msg
  = ChangeUserName UserName
  | SendLogin
  | SendLoginKey Int
  | ReceiveLoginResult LoginResult
  | NewLogin UserName
  | ReceivedChat String
  | ChangeDraft Chat
  | SendChat
  | SendChatKey Int