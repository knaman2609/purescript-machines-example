module Main where

import Data.Maybe
import Prelude

import Control.Monad.Eff (Eff, foreachE)
import Control.Monad.Eff.Console (CONSOLE, log, logShow)
import Data.Machine.Mealy (Step(..), mealy, runMealyT)

foreign import testImpl :: forall eff. String -> String -> Eff eff String
foreign import myLog :: forall eff. String -> Eff eff (Step (Eff eff ) String String)

extract ∷ ∀ m a b. Step m a b → Maybe b
extract (Emit x _) = Just x
extract (Halt) = Nothing

step (Emit _ m)  = Just m
step (Halt)  = Nothing

mcn :: forall eff. String -> String -> Eff eff (Step (Eff eff) String String)
mcn x y = do
  res <- testImpl x y
  pure $ Emit res (mealy $ mcn y)

main = do
  let machine = mealy $ mcn "init"

  x <- runMealyT machine "hi"
  logShow $ extract x

  y <- case (step x) of
            Just m -> runMealyT m "hola"
            Nothing -> myLog "machine halted"
  logShow $ extract y

  z <- case (step y) of
            Just m -> runMealyT m "howdy"
            Nothing -> myLog "machine halted"
  logShow $ extract z


  pure unit
