module Msg exposing(..)

import Model exposing(..)

type Msg
  = ChangeUserName UserName
  | SendLogin
  | SendLoginKey Int
  | ReceiveLoginSuccess Int
  | ReceiveLoginFailed String
  | ReceiveLog String
  | NewLogin UserName
  | ReceivedChat String
  | ChangeDraft Chat
  | SendChat
  | SendChatKey Int