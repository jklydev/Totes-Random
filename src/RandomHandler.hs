{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}

module RandomHandler
(randVal)
where

import TwitSeed
import Info
import System.Random
import System.Random.Mersenne.Pure64
import Data.Aeson (ToJSON(toJSON),FromJSON(..),Value(Object),(.:),encode,decode)
import Network.HTTP.Conduit


data TweetEmbed = TweetEmbed {html :: String } deriving (Show)

instance FromJSON TweetEmbed where
  parseJSON (Object v) = TweetEmbed <$> v .: "html"


getTweet :: String -> IO (Maybe TweetEmbed)
getTweet url = simpleHttp ("https://publish.twitter.com/oembed?url="++ url++"&hide_media=true") >>= return . decode


randVal :: IO String
randVal = do
  (TwitterSeed twint tweets) <- twit
  -- manager <- newManager tlsManagerSettings
  requests <- sequence $ map getTweet tweets
  let requests' = map html $ maybe [] id $ sequence requests
  let mersenne = pureMT $ fromIntegral twint
      randoCalinteger = fst $ randomInt mersenne
      randOfTheKing = fst $ randomR (0,1) (mkStdGen randoCalinteger) :: Double
  (return . show) $ encode (TwitterSeed randOfTheKing requests')
