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
  { userID : Maybe ID
  , username : Maybe UserName
  , logs : List MessageLog
  , draft : Chat
  , currentScene : Scene
  , systemMessage : Maybe String
  }

initModel : Model
initModel =
  { userID = Nothing
  , username = Nothing
  , logs = []
  , draft = ""
  , currentScene = Login
  , systemMessage = Nothing
  }


getUser model =
  case (model.userID, model.username) of
    (Just id, Just name) -> Just (User id name)
    _ -> Nothing


-- isUserSelf : User -> Model ->Bool
-- isUserSelf user model =
--   (Just user.userID == model.userID)
--   && (Just user.name == model.username)