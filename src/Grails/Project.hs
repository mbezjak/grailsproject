module Grails.Project ( detect ) where

import Control.Monad.Error (throwError)
import Control.Applicative ((<|>))

import Grails.Types        (EIO, Properties, Files(..), Project(..))
import Grails.Files        (projectFiles)
import Grails.Parser.BuildConfig as BC
import Grails.Parser.Properties  as PROP
import Grails.Parser.PluginDesc  as PD

detect :: EIO Project
detect = do
  files   <- projectFiles
  props   <- PROP.parse (appProps files)
  plugins <- BC.parse (buildConfig files)
  version <- detectVersion props (pluginDesc files)
  grails  <- lookupGrailsVersion props
  appName <- lookupAppName props
  return (Project plugins version grails appName)


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
