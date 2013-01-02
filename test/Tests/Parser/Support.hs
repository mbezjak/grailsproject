module Tests.Parser.Support where

import Test.Framework    (Test)
import Test.Framework.Providers.HUnit
import Test.HUnit hiding (Test)

import Control.Monad.Error (runErrorT)
import Grails.Types        (EIO)

testParser :: (Eq a, Show a) => (FilePath -> EIO a) -> String -> String -> a -> Test
testParser parse group file expected =
  testCase file $ do
    result <- runErrorT . parse $ resource group file
    assertParser result expected

assertParser :: (Eq a, Show a) => Either String a -> a -> Assertion
assertParser result expected =
  case result of
    Left err -> assertFailure err
    Right xs -> xs @?= expected

resource :: String -> String -> String
resource group file = "test/resource/" ++ group ++ "/" ++ file
