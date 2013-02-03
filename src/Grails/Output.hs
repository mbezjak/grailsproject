module Grails.Output ( printApp ) where

import Data.Maybe      (isJust)
import Data.Char       (toLower)
import System.FilePath (takeBaseName)
import Grails.Types    (Plugins, Files(..), Project(..))

printApp :: Project -> IO ()
printApp (Project files plugins version grails appName workDir) = do
  putStrLn ("is_project true")
  putStrLn ("is_plugin " ++ isPlugin ++ " " ++ desc)
  putStrLn ("version " ++ version)
  putStrLn ("grails "  ++ grails)
  putStrLn ("name "    ++ appName)
  putStrLn ("directory " ++ takeBaseName (root files))
  putStrLn ("workdir " ++ workDir)
  putStrLn ""
  printPlugins plugins
  where
    isPlugin = lowerBool . isJust . pluginDesc $ files
    desc     = maybe "" id . pluginDesc $ files


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
    pad s = s ++ replicate (n - length s) ' '
    join (l,r) = pad l ++ "  " ++ r

lowerBool :: Bool -> String
lowerBool = map toLower . show
