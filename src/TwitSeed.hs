{-# LANGUAGE OverloadedStrings #-}

module TwitSeed
      (twit
      ,TwitterSeed(..)
      ) where

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
-- import Data.Char (ord)
import Info -- twitter API credential
import Data.Hashable
import Data.Aeson (ToJSON(toJSON), object, (.=))

query :: APIRequest StatusesFilter StreamingAPI
query = statusesFilter [Track ["random", "stochastic","probability","randos","entropy","totes random","serendipity","coincidence","surprise","bayes","baes","laplace","unlikely","million to one","lottery","las vegas","monte carlo","monty python","MCMC","astrology"]]
-- query = statusesFilter [Track ["stochastic","probability","entropy","bayes","laplace","MCMC","variational","inference","p-value"]]

data TwitterSeed = TwitterSeed {val::Int , tweets::[String]}

instance ToJSON TwitterSeed where
  toJSON (TwitterSeed v t) = object ["value" .= v, "tweet ids" .= t]

twit :: IO TwitterSeed
twit = do
  mgr <- newManager tlsManagerSettings
  runResourceT $ do
    src <- stream twInfo mgr query
    src $$+- testProc =$= CL.map pipeline =$= CL.isolate 9 =$= CL.fold twitInt (TwitterSeed 0 [])

testProc = do
  tweet <- await
  case tweet of (Just (SStatus status)) -> do
                  --(liftIO . print) (status ^. statusText)
                  yield tweet
                  testProc
                otherwise -> do
                    -- (liftIO . return) ()
                    testProc

twitInt :: TwitterSeed -> Maybe (String,String) -> TwitterSeed
twitInt (TwitterSeed acc ids) (Just (tweet,tweetId)) = TwitterSeed (acc + (hashWithSalt l tweet)) (tweetId:ids)
  where l = length tweet
twitInt acc Nothing = acc


pipeline :: Maybe StreamingAPI -> Maybe (String,String)
pipeline (Just (SStatus status)) = Just $ (tweet, tweetId)
  where tweet = T.unpack $ status ^. statusText
        tweetId = show $ status ^. statusId
pipeline _ = Nothing
