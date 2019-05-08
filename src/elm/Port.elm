port module Port exposing (..)

import Json.Encode

port sendMessage : Json.Encode.Value -> Cmd msg

port receiveMessage : (String -> msg) -> Sub msg

port sendLogin : String -> Cmd msg

port receiveLoginSuccess : (Int -> msg) -> Sub msg
port receiveLoginFailed : (String -> msg) -> Sub msg
port receiveLogin : (String -> msg) -> Sub msg


port loginResult : (String -> msg) -> Sub msg
