{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
import Prelude hiding (readFile, writeFile)
import Data.Map as M
import Text.XML.Stream.Parse
import Filesystem.Path.CurrentOS

main :: IO ()
main = do
    Document prologue root epilogue <- readFile def "Zawya.Sample.xml"

    let context = empty

