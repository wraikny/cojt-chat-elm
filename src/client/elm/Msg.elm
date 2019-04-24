module Msg exposing(..)

type alias Username = String

type alias Chat = String

type Msg
  = ChangeUsername Username
  | SendUsername
  | ReceivedChat Chat
  | ChangeDraft Chat
  | SendChat
