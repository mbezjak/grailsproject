module Grails.Project.Main ( main ) where

import Grails.Project.BuildConfig
import Grails.Project.Util
import Text.ParserCombinators.Parsec

parseBuildConfig :: IO (Either ParseError [(String, String)])
parseBuildConfig = parseFromFile onlyPlugins "grails-app/conf/BuildConfig.groovy"

printPlugins :: [(String, String)] -> IO ()
printPlugins = mapM_ printPlugin . table

printPlugin :: String -> IO ()
printPlugin = putStrLn . renderPlugin

renderPlugin :: String -> String
renderPlugin = ("plugin "++)

main :: IO ()
main = do
  result <- parseBuildConfig
  case result of
    Left err -> print err
    Right xs -> printPlugins xs
