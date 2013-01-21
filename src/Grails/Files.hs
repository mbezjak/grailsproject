module Grails.Files ( projectFiles ) where

import Data.List             (isSuffixOf)
import System.Directory      (getCurrentDirectory, getDirectoryContents)
import System.FilePath.Posix ((</>))
import Control.Monad.Error   (ErrorT(..), lift)

import Grails.Types          (EIO, Files(..))

projectFiles :: EIO Files
projectFiles = do
  cwd  <- lift getCurrentDirectory
  desc <- getPluginDesc cwd

  return (Files {
    root        = cwd,
    appProps    = cwd </> "application.properties",
    buildConfig = cwd </> "grails-app" </> "conf" </> "BuildConfig.groovy",
    pluginDesc  = desc })

getPluginDesc :: FilePath -> EIO (Maybe FilePath)
getPluginDesc = ErrorT . fmap findPluginDesc . getDirectoryContents

findPluginDesc :: [FilePath] -> Either String (Maybe FilePath)
findPluginDesc files =
  case filter isPluginDesc files of
    []  -> Right Nothing
    [x] -> Right (Just x)
    xs  -> Left ("Too many plugin descriptors found: " ++ show xs)

isPluginDesc :: FilePath -> Bool
isPluginDesc = isSuffixOf "GrailsPlugin.groovy"
