module Models.Carrinho where

import Database.PostgreSQL.Simple.FromRow

toString::Carrinho -> String
toString carrinho = 

data Carrinho = carrinho {
    -- To Do...
    -- O carrinho deve ter produtos com suas quantidades    
} deriving (Show, Read, Eq)

instance FromRow Carrinho where
    fromRow = Carrinho -- To Do...