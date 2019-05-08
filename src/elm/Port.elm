port module Port exposing (..)

import Json.Encode

port sendMessage : Json.Encode.Value -> Cmd msg

port receiveMessage : (String -> msg) -> Sub msg

port sendLogin : Json.Encode.Value -> Cmd msg

port receiveLogin : (String -> msg) -> Sub msg


port loginResult : (String -> msg) -> Sub msg
