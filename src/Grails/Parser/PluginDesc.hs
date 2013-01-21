module Grails.Parser.PluginDesc ( parse ) where

import Text.ParserCombinators.Parsec hiding (parse)
import Grails.Parser.Common
import Grails.Types (EIO)

parse :: FilePath -> EIO String
parse = parseFile onlyVersion

onlyVersion :: Parser String
onlyVersion = try defVersion
              <|> (anyToken >> onlyVersion)
              <|> return []

defVersion :: Parser String
defVersion = do
  symbol $ string "def"
  symbol $ string "version"
  symbol equal
  quoted version

version :: Parser String
version = many1 (alphaNum <|> oneOf "_-.")
