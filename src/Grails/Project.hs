module Grails.Project ( detect ) where

import Data.List             (isSuffixOf)
import System.Directory      (getCurrentDirectory, getDirectoryContents)
import System.FilePath.Posix ((</>))
import Control.Monad.Error   (ErrorT(..), throwError, lift)
import Control.Applicative   ((<|>))

import Grails.Types        (EIO, Properties, Plugins, Files(..), Project(..))
import Grails.Parser.BuildConfig as BC
import Grails.Parser.Properties  as PROP
import Grails.Parser.PluginDesc  as PD

detect :: EIO Project
detect = do
  files   <- projectFiles
  props   <- parseApplication files
  plugins <- parseBuildConfig files
  version <- lookupAppVersion props <|> parsePluginDesc
  grails  <- lookupGrailsVersion props
  appName <- lookupAppName props
  return (Project plugins version grails appName)


parseBuildConfig :: Files -> EIO Plugins
parseBuildConfig = BC.parse . buildConfig

parseApplication :: Files -> EIO Properties
parseApplication = PROP.parse . appProps

parsePluginDesc :: EIO String
parsePluginDesc = getPluginDesc "." >>= PD.parse


lookupAppVersion :: Properties -> EIO String
lookupAppVersion = fromApplicationProperties "app.version"

lookupGrailsVersion :: Properties -> EIO String
lookupGrailsVersion = fromApplicationProperties "app.grails.version"

lookupAppName :: Properties -> EIO String
lookupAppName = fromApplicationProperties "app.name"

fromApplicationProperties :: String -> Properties -> EIO String
fromApplicationProperties key props =
  case lookup key props of
    Just x  -> return x
    Nothing -> throwError ("No key `" ++ key ++ "' in application.properties")

projectFiles :: EIO Files
projectFiles = do
  cwd <- lift getCurrentDirectory
  return (Files {
    root        = cwd,
    appProps    = cwd </> "application.properties",
    buildConfig = cwd </> "grails-app" </> "conf" </> "BuildConfig.groovy" })

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
