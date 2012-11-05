module Grails.Output where

import Grails.Types

printPlugins :: Plugins -> IO ()
printPlugins = mapM_ printPlugin . table

printPlugin :: String -> IO ()
printPlugin = putStrLn . renderPlugin

renderPlugin :: String -> String
renderPlugin = ("plugin "++)

table :: [(String,String)] -> [String]
table xs = map join xs
  where
    n = maximum . map (length . fst) $ xs
    pad s = s ++ (replicate (n - length s) ' ')
    join (l,r) = pad l ++ "  " ++ r
