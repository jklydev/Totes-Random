{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Applicative
import Web.Scotty
import RandomHandler
-- import GetInfo (getPortNum)
import qualified Data.ByteString.Lazy as B
import Control.Monad.IO.Class (liftIO)
import System.IO (FilePath,readFile)
import Network.Wai.Middleware.Cors


-- define static directory at some point
-- main2 :: IO ()
main = scotty 8888 $ do
    middleware simpleCors
    get "/rand" $ do
        val <- randHandler
        html $ val
    get "/float" $ do
        val <- floatHandler
        html $ val
    get "/bits" $ do
        val <- bitsHandler
        html $ val
    get "/int" $ do
        val <- intHandler
        html $ val

-- topHandler :: Snap ()
--topHandler = do
--  page <- liftIO $ B.readFile "./index.html"
--  let maybePage = Just page
--  maybe (writeLBS "didn't work") writeLBS maybePage

--bitsHandler :: Snap ()
bitsHandler = do
  val <- liftIO $ randVal' "bits"
  return val

-- intHandler :: Snap ()
intHandler =  do
  val <- liftIO $ randVal' "integer"
  return val

-- floatHandler :: Snap ()
floatHandler =  do
  val <- liftIO $ randVal' "float"
  return val

-- randHandler :: Snap ()
randHandler = do
    val <- liftIO $ randVal
    return val
