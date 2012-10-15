module Grails.Parser.Common where

import Text.ParserCombinators.Parsec

symbol   :: Parser a -> Parser a
symbol p = do
  spaces
  v <- p
  spaces
  return v

quoted   :: Parser a -> Parser a
quoted p = between singleQuote singleQuote p
            <|> between doubleQuote doubleQuote p

parenL      :: Parser Char
parenL      = char '('

parenR      :: Parser Char
parenR      = char ')'

braceL      :: Parser Char
braceL      = char '{'

braceR      :: Parser Char
braceR      = char '}'

comma       :: Parser Char
comma       = char ','

colon       :: Parser Char
colon       = char ':'

singleQuote :: Parser Char
singleQuote = char '\''

doubleQuote :: Parser Char
doubleQuote = char '"'
