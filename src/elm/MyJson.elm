module MyJson exposing(..)

import Model exposing(..)

import Json.Encode as E
import Json.Decode as D
import Json.Decode exposing (Decoder)


encodeUser : User -> E.Value
encodeUser m =
  E.object
    [ ( "userID", E.int m.userID )
    , ( "name", E.string m.name )
    ]

userDecoder : Decoder User
userDecoder =
  D.map2 User
    (D.field "userID" D.int)
    (D.field "name" D.string)


encodeChatMessage : ChatMessage -> E.Value
encodeChatMessage m =
  E.object
    [ ( "user", encodeUser m.user )
    , ( "chat", E.string m.chat )
    ]

chatMessageDecoder : Decoder ChatMessage
chatMessageDecoder =
  D.map2 ChatMessage
    (D.field "user" userDecoder)
    (D.field "chat" D.string)


logDecoder : Decoder MessageLog
logDecoder =
  D.oneOf
    [ userDecoder
      |> D.andThen(LoginLog >> D.succeed)
    , chatMessageDecoder
      |> D.andThen(ChatLog >> D.succeed)
    , D.string
      |> D.andThen(Error >> D.succeed)
    ]