{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE QuasiQuotes #-}

import Control.Exception (Exception)
import Control.Exception.Safe (SomeException, try)
import Control.Monad (join)
import Control.Monad.Except (MonadError(..), ExceptT(..), runExceptT)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Control.Monad.Trans.Class (lift)
import Data.String.Here (i)

-- #@@range_begin(detail)

-- | A throwable exception
newtype MyException = MyException
  { message :: String
  } deriving (Show)

instance Exception MyException

context :: (MonadError MyException m, MonadIO m) => m ()
context = do
  foo <- liftIO . try' $ readFile "foo"
  case foo of
    Left  e -> throwError . MyException $ show e
    Right a -> pure ()
  where
    try' :: IO String -> IO (Either SomeException String)
    try' = try

main :: IO ()
main = do
  x <- runExceptT context
  case x of
    Right e -> putStrLn [i|Succeed: ${e}|]
    Left  a -> putStrLn [i|Failed: ${a}|]
  putStrLn "done"

-- #@@range_end(detail)
