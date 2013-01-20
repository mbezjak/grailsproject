module Grails.Parser.BuildConfig ( parse ) where

import Text.ParserCombinators.Parsec   hiding (parse)
import qualified Text.ParserCombinators.Parsec.Token as T
import Text.ParserCombinators.Parsec.Language (javaStyle)
import Grails.Parser.Common            hiding (symbol, comma)
import Grails.Types (EIO, Plugins)

parse :: FilePath -> EIO Plugins
parse = parseFile onlyPlugins

onlyPlugins :: Parser Plugins
onlyPlugins = try plugins
              <|> (anyToken >> onlyPlugins)
              <|> return []

plugins = do
  symbol "plugins"
  dependenciesBlock

dependenciesBlock = do
  dss <- braces (many dependency)
  return (concat dss)

dependency = do
  lexeme scope
  optional $ lexeme parenL
  -- ugly
  ds <- lexeme (depString <|> (depBlock >> return ("", ""))) `sepBy` comma
  optional $ lexeme parenR
  optional comma
  optional depBlock

  return (filter (not . null . fst) ds)

depBlock = do
  lexeme braceL
  manyTill anyChar (try (lexeme braceR))

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

lexer  = T.makeTokenParser javaStyle
symbol = T.symbol lexer
lexeme = T.lexeme lexer
braces = T.braces lexer
comma  = T.comma  lexer
