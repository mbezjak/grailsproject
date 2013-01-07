module Grails.Project ( detect ) where

import Data.List           (isSuffixOf)
import System.Directory    (getDirectoryContents)
import Control.Monad.Error (ErrorT(..), throwError)
import Control.Applicative ((<|>))

import Grails.Types        (EIO, Properties, Plugins, App(..))
import Grails.Parser.BuildConfig as BC
import Grails.Parser.Properties  as PROP
import Grails.Parser.PluginDesc  as PD

detect :: EIO App
detect = do
  plugins <- parseBuildConfig
  version <- (parseApplication >>= lookupAppVersion) <|> parsePluginDesc
  return (App plugins version)


parseBuildConfig :: EIO Plugins
parseBuildConfig = BC.parse "grails-app/conf/BuildConfig.groovy"

parseApplication :: EIO Properties
parseApplication = PROP.parse "application.properties"

parsePluginDesc :: EIO String
parsePluginDesc = getPluginDesc "." >>= PD.parse


lookupAppVersion :: Properties -> EIO String
lookupAppVersion props =
  case lookup "app.version" props of
    Just app -> return app
    Nothing  -> throwError "No version in properties"

getPluginDesc :: FilePath -> EIO FilePath
getPluginDesc = ErrorT . fmap findPluginDesc . getDirectoryContents

findPluginDesc :: [FilePath] -> Either String FilePath
findPluginDesc files =
  case filter isPluginDesc files of
    []  -> Left "No plugin descriptor found"
    [x] -> Right x
    xs  -> Left ("Too many plugin descriptors found: " ++ show xs)

isPluginDesc :: FilePath -> Bool
isPluginDesc = isSuffixOf "GrailsPlugin.groovy"
