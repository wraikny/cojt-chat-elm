port module Port exposing (receiveMessage, sendMessage)

port sendMessage : String -> Cmd msg

port receiveMessage : (String -> msg) -> Sub msg