module Grails.Project ( detect ) where

import Data.List             (isPrefixOf)
import Control.Monad.Error   (throwError, lift)
import Control.Applicative   ((<|>))
import System.Directory      (getHomeDirectory)
import System.FilePath       (takeBaseName)
import System.FilePath.Posix ((</>))

import Grails.Types          (EIO, Properties, Plugins, Files(..), Project(..))
import Grails.Files          (projectFiles)
import Grails.Parser.BuildConfig as BC
import Grails.Parser.Properties  as PROP
import Grails.Parser.PluginDesc  as PD

detect :: EIO Project
detect = do
  home    <- lift getHomeDirectory
  files   <- projectFiles
  props   <- PROP.parse (appProps files)
  pluginsBC <- BC.parse (buildConfig files)
  let plugins = pluginsBC ++ lookupPlugins props
  version <- detectVersion props (pluginDesc files)
  grails  <- lookupGrailsVersion props
  appName <- lookupAppName props
  let workDir = home </> ".grails" </> grails </> "projects" </> takeBaseName (root files)
  return (Project files plugins version grails appName workDir)


detectVersion :: Properties -> Maybe FilePath -> EIO String
detectVersion props (Just desc) = PD.parse desc <|> lookupAppVersion props
detectVersion props Nothing     = lookupAppVersion props

lookupAppVersion :: Properties -> EIO String
lookupAppVersion = fromApplicationProperties "app.version"

lookupGrailsVersion :: Properties -> EIO String
lookupGrailsVersion = fromApplicationProperties "app.grails.version"

lookupAppName :: Properties -> EIO String
lookupAppName = fromApplicationProperties "app.name"

lookupPlugins :: Properties -> Plugins
lookupPlugins = map (\(k, v) -> (drop (length prefix) k, v)) . filter (isPrefixOf prefix . fst)
  where prefix = "plugins."

fromApplicationProperties :: String -> Properties -> EIO String
fromApplicationProperties key props =
  case lookup key props of
    Just x  -> return x
    Nothing -> throwError ("No key `" ++ key ++ "' in application.properties")
