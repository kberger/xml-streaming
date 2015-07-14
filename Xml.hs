{-# LANGUAGE OverloadedStrings #-}
import Control.Monad.Trans.Resource
import Data.Conduit (($$))
import Data.Conduit.List (sinkNull)
import Data.Text (Text, unpack)
import Text.XML.Stream.Parse
import Text.XML (Name, nameLocalName)

data Person = Person Int Text
    deriving Show

skipTagAndContents n = tagPredicate ((== n) . nameLocalName) ignoreAttrs (const Data.Conduit.List.sinkNull)

isPerson :: Name -> Bool
isPerson name = name == "person"

parsePerson = tagPredicate isPerson (requireAttr "age") $ \age -> do
    name <- content
    return $ Person (read $ unpack age) name

parsePeople = tagNoAttr "people" $ many parsePerson

main = do
    people <- runResourceT $
            parseFile def "Person.xml" $$ force "people required" parsePeople
    print people
