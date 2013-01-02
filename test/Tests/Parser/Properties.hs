module Tests.Parser.Properties (tests) where

import Test.Framework (Test, testGroup)
import Test.Framework.Providers.HUnit
import Test.HUnit hiding (Test)
import Tests.Parser.Support

import Grails.Parser.Properties
import Grails.Types


tests :: Test
tests =
  testGroup "Parser for *.properties file" [
      testEmpty,
      testOnlyComments,
      testProper,
      testApplication
    ]

testEmpty :: Test
testEmpty = testProperties "empty" []

testOnlyComments :: Test
testOnlyComments = testProperties "only-comments" []

testProper :: Test
testProper = testProperties "proper" [
    ("a" , "1"),
    ("b" , "2"),
    ("c" , "3"),
    ("d" , "4"),
    ("keys.with.dots.are.common", "As are values with spaces"),
    ("empty.value", "")
  ]

testApplication :: Test
testApplication = testProperties "application" [
    ("app.grails.version", "1.3.4"),
    ("app.name", "rollback-on-exception"),
    ("plugins.spock", "0.5-groovy-1.7")
  ]

testProperties :: String -> Properties -> Test
testProperties = testParser parse "properties"
