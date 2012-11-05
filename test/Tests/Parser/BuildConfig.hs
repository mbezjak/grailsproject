module Tests.Parser.BuildConfig (tests) where

import Test.Framework (Test, testGroup)
import Test.Framework.Providers.HUnit
import Test.HUnit hiding (Test)
import Tests.Parser.Support

import Text.ParserCombinators.Parsec
import Grails.Parser.BuildConfig
import Grails.Types


tests :: Test
tests =
  testGroup "Parser for BuildConfig.groovy" [
      testNoPlugins,
      testEmptyPlugins,
      testOne,
      testMultiple,
      testNestedBlocks,
      testVersionString
    ]

testNoPlugins :: Test
testNoPlugins = testBuildConfig "no-plugins" []

testEmptyPlugins :: Test
testEmptyPlugins = testBuildConfig "empty-plugins" []

testOne :: Test
testOne = testBuildConfig "one" [("codenarc", "0.17")]

testMultiple :: Test
testMultiple = testBuildConfig "multiple" [
    ("codenarc"              , "0.17"),
    ("hibernate"             , "1.3.7"),
    ("tomcat"                , "1.3.7"),
    ("quartz"                , "0.4.2"),
    ("rollback-on-exception" , "0.1")
  ]

testNestedBlocks :: Test
testNestedBlocks = testBuildConfig "nested-blocks" [
    ("codenarc"              , "0.17"),
    ("spock-core"            , "0.5-groovy-1.8"),
    ("hibernate"             , "1.3.7"),
    ("tomcat"                , "1.3.7"),
    ("quartz"                , "0.4.2"),
    ("rollback-on-exception" , "0.1")
  ]

testVersionString :: Test
testVersionString = testBuildConfig "version-string" [
    ("codenarc"              , "latest.integration"),
    ("hibernate"             , "$grailsVersion"),
    ("tomcat"                , "$grailsVersion"),
    ("quartz"                , "0.4.2"),
    ("rollback-on-exception" , "latest.release")
  ]

testBuildConfig :: String -> Plugins -> Test
testBuildConfig = testParser onlyPlugins "buildconfig"
