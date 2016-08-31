{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Applicative
import Snap.Core
import Snap.Util.FileServe
import Snap.Http.Server
import RandomHandler (randVal)
import qualified Data.ByteString.Char8 as B
import Control.Monad.IO.Class (liftIO)

main :: IO ()
main = quickHttpServe site

site :: Snap ()
site =
    ifTop (writeBS "hello world") <|>
    route [ ("foo", writeBS "bar")
          , ("rand", echoHandler)
          ] <|>
    dir "static" (serveDirectory ".")

echoHandler :: Snap ()
echoHandler = do
    val <- liftIO $ randVal
    let rVal = Just (B.pack $ "Your random number is: " ++ val)
    -- param <- getParam "echoparam"
    maybe (writeBS "failed to generate a random number")
          writeBS rVal
