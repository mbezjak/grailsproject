module Grails.Parser.Properties ( properties ) where

import Text.ParserCombinators.Parsec
import Grails.Parser.Common

properties :: Parser [(String,String)]
properties = many (try onlyProperty)

onlyProperty = do
  skipMany eol
  skipMany comment
  skipMany eol
  p <- property
  skipMany eol
  skipMany comment
  skipMany eol
  return p

property = do
  k <- key
  symbol separator
  v <- value
  return (k, v)

comment = do
  symbol hash
  manyTill anyChar (try end)
  return ()

key   = many1 (alphaNum <|> oneOf "_-.")
value = manyTill anyChar (try end)

separator = equal <|> colon
end       = eol <|> eof
