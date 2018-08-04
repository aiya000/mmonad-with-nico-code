context :: IO ()
context = do
  x <- readFile "nonexistent-file"
  someProcess x
  where
    -- なんらかの処理
    someProcess :: String -> IO ()
    someProcess _ = pure ()

main :: IO ()
main = do
  context
  putStrLn "done"
