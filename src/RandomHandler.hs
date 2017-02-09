{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}

module RandomHandler
    (randVal
    ,randVal'
    ) where


import TwitSeed
-- import Info
import System.Random (random,randomR,randomRs,mkStdGen)
import System.Random.Mersenne.Pure64 (pureMT,randomInt)
import Data.Aeson (ToJSON(toJSON),FromJSON(..),Value(Object),(.:),encode,decode)
import Network.HTTP.Conduit
import qualified Data.Text.Lazy as T
import Data.Text.Lazy.Encoding (encodeUtf8)
import qualified Data.ByteString.Lazy as B


data TweetEmbed = TweetEmbed {html :: String } deriving (Show)

instance FromJSON TweetEmbed where
  parseJSON (Object v) = TweetEmbed <$> v .: "html"


getTweet :: String -> IO (Maybe TweetEmbed)
getTweet url = simpleHttp ("https://publish.twitter.com/oembed?url="++ url++"&hide_media=true") >>= return . decode

-- Random float + html for embedding source tweets
randVal :: IO T.Text
randVal = do
  (TwitterSeed twint tweets) <- twit
  -- manager <- newManager tlsManagerSettings
  requests <- sequence $ map getTweet tweets
  let requests' = map html $ maybe [] id $ sequence requests
  let mersenne = pureMT $ fromIntegral twint
      randoCalinteger = fst $ randomInt mersenne
      randOfTheKing = fst $ randomR (0,1) (mkStdGen randoCalinteger) :: Double
  return $ encode' $ toJSON (TwitterSeed randOfTheKing requests')

encode' :: Show a => a -> T.Text
encode' = T.pack . show

-- Random float
randVal' :: String -> IO T.Text
randVal' rType = do
                  (TwitterSeed twint tweets) <- twit
                  let mersenne = pureMT $ fromIntegral twint
                      randoCalinteger = fst $ randomInt mersenne
                  case rType of "integer" -> (return . encode') $ (fst $ random (mkStdGen randoCalinteger) :: Integer)
                                "bits"    -> (return . encode') $ concatMap show $ take 140 $ (randomRs (0,1) (mkStdGen randoCalinteger) :: [Integer])
                                "float"   -> (return . encode') $ (fst $ randomR (0,1) (mkStdGen randoCalinteger) :: Double)
