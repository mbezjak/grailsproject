module Grails.Project ( detect ) where

import Control.Monad.Error   (throwError, lift)
import Control.Applicative   ((<|>))
import System.Directory      (getHomeDirectory)
import System.FilePath       (takeBaseName)
import System.FilePath.Posix ((</>))

import Grails.Types          (EIO, Properties, Files(..), Project(..))
import Grails.Files          (projectFiles)
import Grails.Parser.BuildConfig as BC
import Grails.Parser.Properties  as PROP
import Grails.Parser.PluginDesc  as PD

detect :: EIO Project
detect = do
  home    <- lift getHomeDirectory
  files   <- projectFiles
  props   <- PROP.parse (appProps files)
  plugins <- BC.parse (buildConfig files)
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

fromApplicationProperties :: String -> Properties -> EIO String
fromApplicationProperties key props =
  case lookup key props of
    Just x  -> return x
    Nothing -> throwError ("No key `" ++ key ++ "' in application.properties")
