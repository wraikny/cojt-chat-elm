port module Port exposing (..)

port sendMessage : String -> Cmd msg

port receiveMessage : (String -> msg) -> Sub msg

port sendLogin : String -> Cmd msg

port receiveLogin : (String -> msg) -> Sub msg