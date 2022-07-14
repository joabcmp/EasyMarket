module Models.Compra where

import Database.PostgreSQL.Simple.FromRow

toString::Compra -> String
toString compra = "Quantidade de itens: " ++ num_itens compra ++ "\nPreço total: " ++ preco compra

data Compra = Compra {
    id_Compra:: Int,
    num_itens:: Int,
    preco:: Double
    -- Uma lista de produtos
} deriving (Show, Read, Eq)

instance FromRow Compra where
    fromRow = Compra <$> field <*> field <*> field