module Grails.Parser.Common where

import Text.ParserCombinators.Parsec
import Control.Monad.Error (ErrorT(..))
import Control.Monad       (void)
import Grails.Types        (EIO)

parseFile :: Parser a -> FilePath -> EIO a
parseFile p = ErrorT . fmap left2str . parseFromFile p
  where
    left2str (Left err) = Left (show err)
    left2str (Right a)  = Right a

symbol   :: Parser a -> Parser a
symbol p = do
  spaces
  v <- p
  spaces
  return v

quoted   :: Parser a -> Parser a
quoted p = between singleQuote singleQuote p
            <|> between doubleQuote doubleQuote p

eol         :: Parser ()
eol         = void (try (string "\r\n")
                    <|> try (string "\n\r")
                    <|> string "\n"
                    <|> string "\r")

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

equal       :: Parser Char
equal       = char '='

hash        :: Parser Char
hash        = char '#'

singleQuote :: Parser Char
singleQuote = char '\''

doubleQuote :: Parser Char
doubleQuote = char '"'
