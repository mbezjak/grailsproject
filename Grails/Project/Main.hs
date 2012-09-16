module Grails.Project.Main ( main ) where

import Grails.Project.BuildConfig
import Text.ParserCombinators.Parsec

parseBuildConfig :: IO (Either ParseError [(String, String)])
parseBuildConfig = parseFromFile onlyPlugins "grails-app/conf/BuildConfig.groovy"

printPlugins :: [(String, String)] -> IO ()
printPlugins = mapM_ printPlugin

printPlugin :: (String, String) -> IO ()
printPlugin = putStrLn . renderPlugin

renderPlugin :: (String, String) -> String
renderPlugin (name, version) = "plugin " ++ name ++ "\t" ++ version

main :: IO ()
main = do
  result <- parseBuildConfig
  case result of
    Left err -> print err
    Right xs -> printPlugins xs