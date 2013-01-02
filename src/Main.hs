import Control.Monad.Error (runErrorT)

import Grails.Types
import Grails.Output
import Grails.Parser.BuildConfig

parseBuildConfig :: EIO Plugins
parseBuildConfig = parse "grails-app/conf/BuildConfig.groovy"

main :: IO ()
main = do
  result <- runErrorT parseBuildConfig
  case result of
    Left err -> print err
    Right xs -> printPlugins xs
