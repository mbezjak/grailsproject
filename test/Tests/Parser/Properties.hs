module Tests.Parser.Properties (tests) where

import Test.Framework (testGroup)
import Test.Framework.Providers.HUnit

import Test.HUnit

import Text.ParserCombinators.Parsec
import Grails.Parser.Properties


tests =
  testGroup "Parser for *.properties file" [
      testParser "empty" [],
      testParser "only-comments" [],
      testParser "proper" proper,
      testParser "application" application
    ]

testParser example expected =
  testCase example $ assertParser (propertiesFile example) expected

propertiesFile example = parseFromFile properties (propertiesFileName example)

propertiesFileName = ("test/resource/properties/"++)

proper = [
    ("a" , "1"),
    ("b" , "2"),
    ("c" , "3"),
    ("d" , "4"),
    ("keys.with.dots.are.common", "As are values with spaces"),
    ("empty.value", "")
  ]

application = [
    ("app.grails.version", "1.3.4"),
    ("app.name", "rollback-on-exception"),
    ("plugins.spock", "0.5-groovy-1.7")
  ]

assertParser parser expected = do
  result <- parser
  case result of
    Left err -> assertFailure (show err)
    Right xs -> xs @?= expected
