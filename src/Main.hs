{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Applicative
import Snap.Core
import Snap.Util.FileServe
import Snap.Http.Server
import RandomHandler
-- import GetInfo (getPortNum)
import qualified Data.ByteString.Char8 as B
import Control.Monad.IO.Class (liftIO)
import System.IO (FilePath,readFile)
-- import            Heist
-- import            Heist.Interpreted
-- import qualified  Data.Text as T
-- import qualified  Text.XmlHtml as X

main :: IO ()
main = quickHttpServe site

site :: Snap ()
site =
    ifTop topHandler <|>
    route [("rand", echoHandler),
           ("float",floatHandler),
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
bitsHandler = do
  val <- liftIO $ randVal' "bits"
  let rVal = Just (B.pack val)
  maybe(writeBS "failed to generate random bits") writeBS rVal

intHandler :: Snap ()
intHandler =  do
  val <- liftIO $ randVal' "integer"
  let rVal = Just (B.pack val)
  maybe(writeBS "failed to generate a random interger") writeBS rVal

floatHandler :: Snap ()
floatHandler =  do
  val <- liftIO $ randVal' "float"
  let rVal = Just (B.pack val)
  maybe(writeBS "failed to generate random bits") writeBS rVal

echoHandler :: Snap ()
echoHandler = do
    val <- liftIO $ randVal
    let rVal = Just (B.pack val)
    -- param <- getParam "echoparam"
    maybe (writeBS "failed to generate a random number")
          writeBS rVal

-- portSplice :: Splice Snap
-- portSplice = do
--     port <- liftIO getPortNum
--     let newURL = "http://totes-random.website/rand"
--     -- input <- getParamNode
--     -- let text = T.unpack $ X.nodeText input
--         -- n = read text :: Int
--     return [X.TextNode $ T.pack $ port]
