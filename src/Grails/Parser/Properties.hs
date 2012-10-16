module Grails.Parser.Properties ( properties ) where

import Text.ParserCombinators.Parsec
import Grails.Parser.Common

properties :: Parser [(String,String)]
properties = fmap (\x -> [x]) line

line = do
  key <- manyTill anyChar (try separator)
  separator
  value <- manyTill anyChar (try eol)
  return (key, value)

comment = do
  hash
  manyTill anyChar (try eol)
  return ()

separator = oneOf " =:"