module Main where

import Control.Monad.Aff
import Control.Monad.Aff.Console
import Control.Monad.Eff
import Data.Either
import Data.Maybe
import Prelude

import Data.Machine.Mealy (Step(..), fromMaybe, mealy, runMealyT)
import Partial.Unsafe (unsafePartial, unsafePartialBecause)

foreign import testImpl :: forall eff. Int -> Int -> (Int -> Eff eff Unit) -> Eff eff Unit

asyncTestImpl a s = makeAff (\callback -> do
  testImpl a s (\ x -> callback $ Right x)
  pure $ nonCanceler)

extract ∷ ∀ m a b. Step m a b → Maybe b
extract (Emit x _) = Just x
extract (Halt) = Nothing

step (Emit _ m)  = Just m
step (Halt)  = Nothing


mcn :: forall eff. Int -> Int -> Aff eff (Step (Aff eff) Int Int)
mcn x y = do
  res <- asyncTestImpl x y
  pure $ Emit res (mealy $ mcn res)

main = launchAff $ unsafePartial $  do
  let machine = mealy $ mcn 1

  x <- runMealyT machine 2
  y <- runMealyT  (fromJust (step x)) 3
  z <- runMealyT  (fromJust (step y)) 4

  logShow $ extract z

  pure unit
