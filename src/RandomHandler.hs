{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}

module RandomHandler
(randVal)
where

import TwitSeed
import Info
import System.Random
import System.Random.Mersenne.Pure64
import Data.Aeson (ToJSON(toJSON),encode)

randVal :: IO String
randVal = do
  (TwitterSeed twint tweets) <- twit
  let mersenne = pureMT $ fromIntegral twint
      randoCalinteger = fst $ randomInt mersenne
      randOfTheKing = fst $ randomR (0,1) (mkStdGen randoCalinteger) :: Double
  (return . show) $ encode (TwitterSeed randoCalinteger tweets)
