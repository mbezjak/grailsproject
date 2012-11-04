module Tests.Parser.Support where

import Test.Framework (Test)
import Test.Framework.Providers.HUnit
import Test.HUnit hiding (Test)

import Text.ParserCombinators.Parsec

testParser :: (Eq a, Show a) => Parser a -> String -> String -> a -> Test
testParser parser group file expected =
  testCase file $ do
    result <- parseFromFile parser (resource group file)
    assertParser result expected

assertParser :: (Eq a, Show a) => Either ParseError a -> a -> Assertion
assertParser result expected =
  case result of
    Left err -> assertFailure (show err)
    Right xs -> xs @?= expected

resource :: String -> String -> String
resource group file = "test/resource/" ++ group ++ "/" ++ file
