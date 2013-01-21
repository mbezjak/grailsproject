module Grails.Output ( printApp ) where

import Grails.Types (Plugins, App(..))

printApp :: App -> IO ()
printApp (App plugins version grails appName) = do
  putStrLn ("version " ++ version)
  putStrLn ("grails "  ++ grails)
  putStrLn ("name "    ++ appName)
  putStrLn ""
  printPlugins plugins


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
