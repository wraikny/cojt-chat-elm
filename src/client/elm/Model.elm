module Model exposing(..)

type alias ID = Int

type alias UserName = String

type alias Chat = String


type alias User =
  { userID : ID
  , name : UserName
  }

type alias ChatMessage =
  { user : User
  , chat : Chat
  }


type MessageLog
  = ChatLog ChatMessage
  | LoginLog User


type Scene
  = Login
  | Logging
  | Chat


type alias Model =
  { userID : ID
  , logs : List MessageLog
  , draft : Chat
  , username : Maybe UserName
  , currentScene : Scene
  , systemMessage : Maybe String
  }


isUserSelf : User -> Model ->Bool
isUserSelf user model =
  (user.userID == model.userID)
  && (Just user.name == model.username)