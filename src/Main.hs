module Main where

import TwitSeed
import Info
import System.Random
import System.Random.Mersenne.Pure64

main :: IO ()
main = do
  twint <- twit
  let mersenne = pureMT $ fromIntegral twint
      randoCalinteger = fst $ randomInt mersenne
      randOfTheKing = fst $ randomR (0,1) (mkStdGen randoCalinteger) :: Double
  -- let twint = 0
  print randOfTheKing