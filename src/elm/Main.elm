module Main exposing (..)

import Browser
import Http
import Random

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
    [ receiveLoginSuccess (ReceiveLoginSuccess)
    , receiveLoginFailed (ReceiveLoginFailed)
    , receiveMessage ReceivedChat
    , receiveLogin  NewLogin
    , receiveServerLog ReceiveLog
    ]


init : () -> ( Model, Cmd Msg )
init _ =
  ( initModel, Cmd.none )