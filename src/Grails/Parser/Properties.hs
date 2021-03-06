module Grails.Parser.Properties ( parse ) where

import Text.ParserCombinators.Parsec hiding (parse)
import Grails.Parser.Common
import Grails.Types (EIO, Properties)

parse :: FilePath -> EIO Properties
parse = parseFile properties

properties :: Parser Properties
properties = many (try onlyProperty)

onlyProperty = do
  ignored
  p <- property
  ignored
  return p

ignored = do
  skipMany eol
  skipMany comment
  skipMany eol

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
