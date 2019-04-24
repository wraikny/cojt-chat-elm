module Msg exposing(..)

type alias Username = String

type alias Chat = String

type Msg
  = ChangeUsername Username
  | SendLogin
  | NewLogin Username
  | ReceivedChat Chat
  | ChangeDraft Chat
  | SendChat
