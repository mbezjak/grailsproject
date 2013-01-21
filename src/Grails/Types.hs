module Grails.Types where

import Control.Monad.Error (ErrorT(..))

type EIO = ErrorT String IO

type Plugins    = [(String,String)]
type Properties = [(String,String)]


data Files = Files { root        :: FilePath
                   , appProps    :: FilePath
                   , buildConfig :: FilePath }
           deriving Show

data Project = Project { getPlugins       :: Plugins
                       , getVersion       :: String
                       , getGrailsVersion :: String
                       , getAppName       :: String }
