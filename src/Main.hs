{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Applicative
import Snap.Core
import Snap.Util.FileServe
import Snap.Http.Server
import RandomHandler (randVal)
import qualified Data.ByteString.Char8 as B
import Control.Monad.IO.Class (liftIO)
import System.IO (FilePath,readFile)

main :: IO ()
main = quickHttpServe site

site :: Snap ()
site =
    ifTop topHandler <|>
    route [("rand", echoHandler),
           ("bits",bitsHandler),
           ("int",intHandler)
          ] <|>
    dir "static" (serveDirectory ".")

topHandler :: Snap ()
topHandler = do
  page <- liftIO $ readFile "./index.html"
  let maybePage = Just (B.pack page)
  maybe (writeBS "didn't work") writeBS maybePage

bitsHandler :: Snap ()
bitsHandler = undefined

intHandler :: Snap ()
intHandler = undefined

echoHandler :: Snap ()
echoHandler = do
    val <- liftIO $ randVal
    let rVal = Just (B.pack val)
    -- param <- getParam "echoparam"
    maybe (writeBS "failed to generate a random number")
          writeBS rVal
