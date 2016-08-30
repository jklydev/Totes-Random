{-# LANGUAGE OverloadedStrings #-}

module TwitSeed
      (twit
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
import Data.Char (ord)
import Info -- twitter API credentials
import Data.Hashable

query :: APIRequest StatusesFilter StreamingAPI
query = statusesFilter [Track ["random", "stochastic","probability","randos","entropy","totes random","serendipity","coincidence","surprise","bayes","baes","laplace","unlikely","million to one","lottery","las vegas","monte carlo","monty python","MCMC","astrology"]]
-- query = statusesFilter [Track ["stochastic","probability","entropy","bayes","laplace","MCMC","variational","inference","p-value"]]

twit :: IO Int
twit = do
  mgr <- newManager tlsManagerSettings
  runResourceT $ do
    src <- stream twInfo mgr query
    src $$+- testProc =$= CL.map pipeline =$= CL.isolate 9 =$= CL.fold twitInt 0

testProc = do
  tweet <- await
  case tweet of (Just (SStatus status)) -> do
                  --(liftIO . print) (status ^. statusText)
                  yield tweet
                  testProc
                otherwise -> do
                    -- (liftIO . return) ()
                    testProc

twitInt :: Int -> Maybe String -> Int
twitInt acc (Just tweet) = acc + (hashWithSalt l tweet) -- (sum $ Prelude.map ord tweet)
  where l = length tweet
twitInt acc Nothing = acc


pipeline :: Maybe StreamingAPI -> Maybe String
pipeline (Just (SStatus status)) = Just $ T.unpack tweet
  where tweet = status ^. statusText
pipeline _ = Nothing
