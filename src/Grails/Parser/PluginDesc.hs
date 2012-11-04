module Grails.Parser.PluginDesc ( onlyVersion ) where

import Text.ParserCombinators.Parsec
import Grails.Parser.Common

onlyVersion :: Parser String
onlyVersion = try defVersion
              <|> (anyToken >> onlyVersion)
              <|> return []

defVersion :: Parser String
defVersion = do
  symbol $ string "def"
  symbol $ string "version"
  symbol $ equal
  quoted version

version :: Parser String
version = many1 (alphaNum <|> oneOf "_-.")
