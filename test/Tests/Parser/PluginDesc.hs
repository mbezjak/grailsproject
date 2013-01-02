module Tests.Parser.PluginDesc (tests) where

import Test.Framework (Test, testGroup)
import Test.Framework.Providers.HUnit
import Test.HUnit hiding (Test)
import Tests.Parser.Support

import Grails.Parser.PluginDesc


tests :: Test
tests =
  testGroup "Parser for *GrailsPlugin.groovy" [testSimple]

testSimple :: Test
testSimple = testPluginDesc "simple" "1.4.7-rc1"

testPluginDesc :: String -> String -> Test
testPluginDesc = testParser parse "plugindesc"
