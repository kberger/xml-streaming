{-# LANGUAGE OverloadedStrings #-}
import Control.Monad.Trans.Resource
import Data.Conduit (($$))
import Data.Conduit.List (sinkNull)
import Data.Map (Map, empty, insert)
import Data.Text (Text, unpack)
import Text.XML.Stream.Parse
import Text.XML (Name, nameLocalName)

data Person = Person Int Text
    deriving Show

parsePerson map = tagName "person" (requireAttr "age") (\age -> do
    name <- content
    return $ Person (read (unpack age)) name)

parsePeople = parsePeople' empty

parsePeople' map = tagNoAttr "people" (many (parsePerson map))

main = do
    people <- runResourceT (parseFile def "Person.xml" $$ force "people required" parsePeople)
    print people
