import Test.Framework (defaultMain)

import qualified Tests.BuildConfig

main :: IO ()
main = defaultMain [ Tests.BuildConfig.tests ]
