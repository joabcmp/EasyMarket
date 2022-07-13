module Models.Adm where

import Database.PostgreSQL.Simple.FromRow

toString::Adm -> String
toString adm = "Nome: " ++ nome adm ++ "\nLogin: " ++ login adm

data Adm = Adm {
    id_Adm:: Int,
    nome:: String,
    login:: String,
    senha:: String
} deriving (Show, Read, Eq)

instance FromRow Adm where
    fromRow = Adm <$> field <*> field <*> field <*> field