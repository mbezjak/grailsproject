import Grails.Parser.BuildConfig
import Grails.Output
import Text.ParserCombinators.Parsec

parseBuildConfig :: IO (Either ParseError [(String, String)])
parseBuildConfig = parseFromFile onlyPlugins "grails-app/conf/BuildConfig.groovy"

main :: IO ()
main = do
  result <- parseBuildConfig
  case result of
    Left err -> print err
    Right xs -> printPlugins xs
