import Test.Framework (defaultMain)

import qualified Tests.Parser.BuildConfig

main :: IO ()
main = defaultMain [ Tests.Parser.BuildConfig.tests ]
