module Models.Carrinho where

import Database.PostgreSQL.Simple.FromRow
 

toString::[Carrinho] -> String
toString [] = ""
toString (carrinho:[]) = "Id_Cliente: " ++ show (id_cliente carrinho) ++ " | Id_Produto: " ++ show (id_produto carrinho) ++ " | Quantidade Produto: " ++ show (quantidadeDoProduto carrinho) ++ " | Nome Produto: " ++ nomeProduto carrinho ++ " | Preço: " ++ show(preco carrinho) 

data Carrinho = Carrinho {
    id_cliente:: Int,
    id_produto:: Int,
    quantidadeDoProduto:: Int,
    nomeProduto::String,
    preco::Float
} deriving (Show, Read, Eq)

instance FromRow Carrinho where
    fromRow = Carrinho <$> field <*> field <*> field <*> field <*> field 