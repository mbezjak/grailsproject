module Grails.Project ( detect ) where

import Data.List        (isSuffixOf)
import Data.Maybe       (listToMaybe)
import System.Directory (getDirectoryContents)

import Grails.Types     (EIO, Properties, Plugins, App(..))
import Grails.Parser.BuildConfig as BC
import Grails.Parser.Properties  as PROP

detect :: EIO App
detect = do
  plugins <- parseBuildConfig
  props   <- parseApplication
  return (App plugins (lookupAppVersion props))


parseBuildConfig :: EIO Plugins
parseBuildConfig = BC.parse "grails-app/conf/BuildConfig.groovy"

parseApplication :: EIO Properties
parseApplication = PROP.parse "application.properties"


lookupAppVersion :: Properties -> Maybe String
lookupAppVersion = lookup "app.version"

getPluginDesc :: FilePath -> IO (Maybe FilePath)
getPluginDesc = fmap findPluginDesc . getDirectoryContents

findPluginDesc :: [FilePath] -> Maybe FilePath
findPluginDesc = listToMaybe . filter isPluginDesc

isPluginDesc :: FilePath -> Bool
isPluginDesc = isSuffixOf "GrailsPlugin.groovy"
