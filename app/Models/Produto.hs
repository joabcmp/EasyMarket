module Models.Produto where

import Database.PostgreSQL.Simple.FromRow

toString::Produto -> String
toString produto = "Nome: " ++ nome produto ++ "\nFabricante: " ++ fabricante produto ++ "\nPreço: " ++ preco produto

data Produto = produto {
    id_Produto:: Int,
    nome:: String,
    fabricante:: String,
    preco:: Double
} deriving (Show, Read, Eq)

instance FromRow Produto where
    fromRow = Produto <$> field <*> field <*> field <*> field