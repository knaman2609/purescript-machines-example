module Main where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Machine.Mealy (MealyT(..), Step(..), runMealyT)

foreign import testImpl :: forall eff. String -> Eff eff String

test :: forall eff. String -> Eff eff (Step (Eff eff) String String)
test inp = do
  x <- testImpl inp
  pure $ Emit x (MealyT $ test)

fn :: forall eff. MealyT (Eff eff) String String
fn = MealyT $ test

main = do
  machine1 <- runMealyT  fn "hello"
  pure unit
