import Test.Framework (defaultMain)

import qualified Tests.Parser.BuildConfig
import qualified Tests.Parser.Properties

main :: IO ()
main = defaultMain [ Tests.Parser.BuildConfig.tests
                   , Tests.Parser.Properties.tests
                   ]
