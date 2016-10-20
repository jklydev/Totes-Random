{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Applicative
import Snap.Core
import Snap.Util.FileServe
import Snap.Http.Server
import RandomHandler
-- import GetInfo (getPortNum)
import qualified Data.ByteString.Lazy as B
import Control.Monad.IO.Class (liftIO)
import System.IO (FilePath,readFile)


main :: IO ()
main = quickHttpServe site

site :: Snap ()
site =
    ifTop topHandler <|>
    route [("rand", randHandler),
           ("float",floatHandler),
           ("bits",bitsHandler),
           ("int",intHandler)
          ] <|>
    dir "static" (serveDirectory ".")

topHandler :: Snap ()
topHandler = do
  page <- liftIO $ B.readFile "./index.html"
  let maybePage = Just page
  maybe (writeLBS "didn't work") writeLBS maybePage

bitsHandler :: Snap ()
bitsHandler = do
  val <- liftIO $ randVal' "bits"
  let rVal = Just val
  maybe(writeLBS "failed to generate random bits") writeLBS rVal

intHandler :: Snap ()
intHandler =  do
  val <- liftIO $ randVal' "integer"
  let rVal = Just val
  maybe(writeLBS "failed to generate a random interger") writeLBS rVal

floatHandler :: Snap ()
floatHandler =  do
  val <- liftIO $ randVal' "float"
  let rVal = Just val
  maybe(writeLBS "failed to generate random bits") writeLBS rVal

randHandler :: Snap ()
randHandler = do
    val <- liftIO $ randVal
    let rVal = Just val
    -- param <- getParam "echoparam"
    maybe (writeLBS "failed to generate a random number")
          writeLBS rVal
