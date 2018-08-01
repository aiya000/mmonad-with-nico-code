import Control.Monad.IO.Class (MonadIO)
import Control.Monad.Trans.State.Lazy (StateT, runStateT)
import Control.Monad.Trans.Class (lift)

f :: StateT Int IO Char
f = do
  -- lift :: IO () -> StateT Int IO ()
  lift $ putStrLn "in the context of StateT Int IO"
  return 'a'

main :: IO ()
main = do
  x <- runStateT f 10
  print x
