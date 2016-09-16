{-# LANGUAGE OverloadedStrings, GADTs #-}

module TwitSeed
      (twit
      ,TwitterSeed(..)
      ) where

import GetInfo
import Web.Twitter.Conduit
import Web.Twitter.Conduit.Stream
import Web.Twitter.Types.Lens
import Data.Conduit
import qualified Data.Conduit.List as CL
import qualified Data.Text as T
import qualified Data.Text.IO as T
import Control.Monad.IO.Class (liftIO)
import Control.Lens ((^.))
import Control.Monad.Trans.Resource (runResourceT)
-- import Info -- twitter API credential
import Data.Hashable
import Data.Aeson (ToJSON(toJSON), object, (.=))

query :: APIRequest StatusesFilter StreamingAPI
query = statusesFilter [Track ["random", "gaussian","cauchy","exponential","gamma","the hulk",
  "chi-squared","chai latte","wishart","correlation","implies","causality","stochastic",
  "bayes","baes","laplace","unlikely","million to one","lottery","las vegas","distribution",
  "monte carlo","monty python","MCMC","astrology","accidental","heart of gold"]]

data TwitterSeed a = TwitterSeed {val::a , tweets::[String]}

instance (ToJSON a) => ToJSON (TwitterSeed a) where
  toJSON (TwitterSeed v t) = object ["value" .= v, "tweet ids" .= t]

twit :: IO (TwitterSeed Int)
twit = do
  twInfo <- getTWInfoFromEnv
  mgr <- newManager tlsManagerSettings
  runResourceT $ do
    src <- stream twInfo mgr query
    src $$+- testProc =$= CL.map pipeline =$= CL.isolate 9 =$= CL.fold twitInt (TwitterSeed 0 [])

testProc = do
  tweet <- await
  case tweet of (Just (SStatus status)) -> do
                  yield tweet
                  testProc
                otherwise -> do
                    testProc

makeURL :: (String, String) -> String
makeURL (userID,tweetId) = "https://twitter.com/" ++ userID ++ "/status/" ++ tweetId

twitInt :: TwitterSeed Int -> Maybe (String,(String,String)) -> TwitterSeed Int
twitInt (TwitterSeed acc ids) (Just (tweet,tweetId)) = TwitterSeed (acc + (hashWithSalt l tweet)) ((makeURL tweetId):ids)
  where l = length tweet
twitInt acc Nothing = acc


pipeline :: Maybe StreamingAPI -> Maybe (String,(String,String))
pipeline (Just (SStatus status)) = Just $ (tweet, tweetId)
  where tweet = T.unpack $ status ^. statusText
        tweetId = (T.unpack (status ^. user . userScreenName), show $ status ^. statusId)
pipeline _ = Nothing
