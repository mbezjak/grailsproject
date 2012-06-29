import Text.ParserCombinators.Parsec

onlyPlugins :: Parser [(String,String)]
onlyPlugins = do
  manyTill anyChar (lookAhead $ try plugins)
  ps <- plugins
  many anyChar
  return ps

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

depString  = between singleQuote singleQuote depSpec
             <|> between doubleQuote doubleQuote depSpec

depSpec    = do
  optional groupId
  colon
  a <- artifactId
  colon
  v <- version
  return (a, v)

scope          = many1 letter
groupId        = identifier
artifactId     = identifier
version        = identifier
identifier     = many1 (alphaNum <|> oneOf "_-.")

symbol p = do
  spaces
  v <- p
  spaces
  return v

parenL      = char '('
parenR      = char ')'
braceL      = char '{'
braceR      = char '}'
comma       = char ','
colon       = char ':'
singleQuote = char '\''
doubleQuote = char '"'
