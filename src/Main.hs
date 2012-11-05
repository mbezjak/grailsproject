import Grails.Types
import Grails.Output
import Grails.Parser.BuildConfig
import Text.ParserCombinators.Parsec

parseBuildConfig :: IO (Either ParseError Plugins)
parseBuildConfig = parseFromFile onlyPlugins "grails-app/conf/BuildConfig.groovy"

main :: IO ()
main = do
  result <- parseBuildConfig
  case result of
    Left err -> print err
    Right xs -> printPlugins xs
