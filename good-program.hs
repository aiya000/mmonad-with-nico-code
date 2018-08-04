{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE QuasiQuotes #-}

import Control.Exception (IOException)
import Control.Exception.Safe (SomeException, try)
import Control.Monad (join)
import Control.Monad.Except (MonadError(..), ExceptT(..), runExceptT)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Control.Monad.Morph ((|>=))
import Control.Monad.Trans.Class (lift)
import Data.String.Here (i)

-- #@@range_begin(detail)

check :: IO a -> ExceptT IOException IO a
check = ExceptT . try

context :: (MonadError IOException m, MonadIO m) => m ()
context = do
  x <- liftIO $ readFile "nonexistent-file"
  liftIO $ someProcess x
  where
    -- なんらかの処理
    someProcess :: String -> IO ()
    someProcess _ = pure ()

main :: IO ()
main = do
  x <- runExceptT $ context |>= check
  case x of
    Right e -> putStrLn [i|Succeed: ${e}|]
    Left  a -> putStrLn [i|Failed: ${a}|]
  putStrLn "done"

-- #@@range_end(detail)
