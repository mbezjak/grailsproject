module Grails.Parser.BuildConfig ( parse ) where

import Text.ParserCombinators.Parsec hiding (parse)
import Grails.Parser.Common
import Grails.Types (EIO, Plugins)

parse :: FilePath -> EIO Plugins
parse = parseFile onlyPlugins

onlyPlugins :: Parser Plugins
onlyPlugins = try plugins
              <|> (anyToken >> onlyPlugins)
              <|> return []

plugins = do
  symbol $ string "plugins"
  dependenciesBlock

dependenciesBlock = between (symbol braceL) (symbol braceR) (many dependency)

dependency = do
  symbol scope
  optional $ symbol parenL
  d <- symbol depString
  optional $ symbol parenR
  optional $ symbol comma
  optional depBlock

  return d

depBlock = do
  symbol braceL
  manyTill anyChar (try (symbol braceR))

depString = quoted depSpec

depSpec   = do
  optional groupId
  colon
  a <- artifactId
  colon
  v <- version
  return (a, v)

scope      = many1 letter
groupId    = identifier
artifactId = identifier
version    = identifier
identifier = many1 (alphaNum <|> oneOf "_-.$")
