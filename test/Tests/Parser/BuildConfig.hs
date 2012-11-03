module Tests.Parser.BuildConfig (tests) where

import Test.Framework (testGroup)
import Test.Framework.Providers.HUnit
import Test.HUnit
import Tests.Parser.Support

import Text.ParserCombinators.Parsec
import Grails.Parser.BuildConfig


tests =
  testGroup "Parser for BuildConfig.groovy" [
      testNoPlugins,
      testEmptyPlugins,
      testOne,
      testMultiple,
      testNestedBlocks,
      testVersionString
    ]

testNoPlugins = testBuildConfig "no-plugins" []

testEmptyPlugins = testBuildConfig "empty-plugins" []

testOne = testBuildConfig "one" [("codenarc", "0.17")]

testMultiple = testBuildConfig "multiple" [
    ("codenarc"              , "0.17"),
    ("hibernate"             , "1.3.7"),
    ("tomcat"                , "1.3.7"),
    ("quartz"                , "0.4.2"),
    ("rollback-on-exception" , "0.1")
  ]

testNestedBlocks = testBuildConfig "nested-blocks" [
    ("codenarc"              , "0.17"),
    ("spock-core"            , "0.5-groovy-1.8"),
    ("hibernate"             , "1.3.7"),
    ("tomcat"                , "1.3.7"),
    ("quartz"                , "0.4.2"),
    ("rollback-on-exception" , "0.1")
  ]

testVersionString = testBuildConfig "version-string" [
    ("codenarc"              , "latest.integration"),
    ("hibernate"             , "$grailsVersion"),
    ("tomcat"                , "$grailsVersion"),
    ("quartz"                , "0.4.2"),
    ("rollback-on-exception" , "latest.release")
  ]

testBuildConfig = testParser onlyPlugins "buildconfig"
