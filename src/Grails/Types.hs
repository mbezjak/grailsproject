module Grails.Types where

import Control.Monad.Error

type EIO = ErrorT String IO

type Plugins = [(String,String)]
type Properties = [(String,String)]
