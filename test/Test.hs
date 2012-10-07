import Test.Framework (defaultMain)
import Tests.BuildConfig

main = defaultMain tests

tests = [parserForBuildConfig]
