module Grails.Project ( getPluginDesc ) where

import Data.List  (isSuffixOf)
import Data.Maybe (listToMaybe)
import System.Directory (getDirectoryContents)

import Grails.Types

getPluginDesc :: FilePath -> IO (Maybe FilePath)
getPluginDesc = fmap findPluginDesc . getDirectoryContents

findPluginDesc :: [FilePath] -> Maybe FilePath
findPluginDesc = listToMaybe . filter isPluginDesc

isPluginDesc :: FilePath -> Bool
isPluginDesc = isSuffixOf "GrailsPlugin.groovy"
