module Tests.BuildConfig (tests) where

import Test.Framework (testGroup)
import Test.Framework.Providers.HUnit

import Test.HUnit

import Text.ParserCombinators.Parsec
import Grails.Project.BuildConfig


tests =
  testGroup "Parser for BuildConfig.groovy" [
      testParser "no-plugins" [],
      testParser "empty-plugins" [],
      testParser "one" [("codenarc", "0.17")],
      testParser "multiple" multiplePlugins,
      testParser "nested-blocks" nestedBlocksPlugins,
      testParser "version-string" versionStringPlugins
    ]

testParser example expected =
  testCase example $ assertParser (plugins example) expected

plugins example = parseFromFile onlyPlugins (buildConfig example)

buildConfig = ("test/resource/buildconfig/"++)

multiplePlugins = [
    ("codenarc"              , "0.17"),
    ("hibernate"             , "1.3.7"),
    ("tomcat"                , "1.3.7"),
    ("quartz"                , "0.4.2"),
    ("rollback-on-exception" , "0.1")
  ]

nestedBlocksPlugins = [
    ("codenarc"              , "0.17"),
    ("spock-core"            , "0.5-groovy-1.8"),
    ("hibernate"             , "1.3.7"),
    ("tomcat"                , "1.3.7"),
    ("quartz"                , "0.4.2"),
    ("rollback-on-exception" , "0.1")
  ]

versionStringPlugins = [
    ("codenarc"              , "latest.integration"),
    ("hibernate"             , "$grailsVersion"),
    ("tomcat"                , "$grailsVersion"),
    ("quartz"                , "0.4.2"),
    ("rollback-on-exception" , "latest.release")
  ]

assertParser parser expected = do
  result <- parser
  case result of
    Left err -> assertFailure (show err)
    Right xs -> xs @?= expected
