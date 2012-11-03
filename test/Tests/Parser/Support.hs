module Tests.Parser.Support where

import Test.Framework.Providers.HUnit
import Test.HUnit

import Text.ParserCombinators.Parsec

testParser parser group file expected =
  testCase file $ do
    result <- parseFromFile parser (resource group file)
    assertParser result expected

assertParser result expected =
  case result of
    Left err -> assertFailure (show err)
    Right xs -> xs @?= expected

resource :: String -> String -> String
resource group file = "test/resource/" ++ group ++ "/" ++ file
