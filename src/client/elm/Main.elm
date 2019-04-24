module Main exposing (..)

import Browser
import Http
import Model exposing(..)
import View exposing(..)
import Update exposing(..)
import Msg exposing(..)
import Port exposing(..)

-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ receiveMessage ReceivedChat
    , receiveLogin  NewLogin
    ]