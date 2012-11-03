module Tests.Parser.Properties (tests) where

import Test.Framework (testGroup)
import Test.Framework.Providers.HUnit
import Test.HUnit
import Tests.Parser.Support

import Text.ParserCombinators.Parsec
import Grails.Parser.Properties


tests =
  testGroup "Parser for *.properties file" [
      testEmpty,
      testOnlyComments,
      testProper,
      testApplication
    ]

testEmpty = testProperties "empty" []

testOnlyComments = testProperties "only-comments" []

testProper = testProperties "proper" [
    ("a" , "1"),
    ("b" , "2"),
    ("c" , "3"),
    ("d" , "4"),
    ("keys.with.dots.are.common", "As are values with spaces"),
    ("empty.value", "")
  ]

testApplication = testProperties "application" [
    ("app.grails.version", "1.3.4"),
    ("app.name", "rollback-on-exception"),
    ("plugins.spock", "0.5-groovy-1.7")
  ]

testProperties = testParser properties "properties"
