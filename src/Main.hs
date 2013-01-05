import Control.Monad.Error (runErrorT)

import Grails.Project (detect)
import Grails.Output  (printApp)

main :: IO ()
main = do
  result <- runErrorT detect
  case result of
    Left err  -> print err
    Right app -> printApp app
