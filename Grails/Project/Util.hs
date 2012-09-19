module Grails.Project.Util where

table :: [(String,String)] -> [String]
table xs = map join xs
  where
    n = maximum . map (length . fst) $ xs
    pad s = s ++ (replicate (n - length s) ' ')
    join (l,r) = pad l ++ "  " ++ r
