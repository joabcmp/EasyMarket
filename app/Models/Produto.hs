module Models.Produto where
import Database.PostgreSQL.Simple.FromRow

toString::Produto -> String
toStringList::[Produto] -> String


toString produto = "ID do produto: " ++ show (id_Produto produto)  ++ "\nNome: " ++ nome produto ++ "\nPreço: " ++ show (preco produto) ++ "\nDescrição: " ++ descricao produto ++ "\nQuantidade no Estoque: " ++ show (quantidadeEstoque produto) ++ "\nID do estabelecimento: " ++ show (id_Estabelecimento produto)

toStringList (produto:[]) = "ID do produto: " ++ show (id_Produto produto)  ++ " | Nome: " ++ nome produto ++ " | Preço: " ++ show (preco produto) ++ " | Descrição: " ++ descricao produto ++ " | Quantidade no Estoque: " ++ show (quantidadeEstoque produto) ++ " | ID do estabelecimento: " ++ show (id_Estabelecimento produto) ++ "|\n"
toStringList (produto:t) = "ID do produto: " ++ show (id_Produto produto)  ++ " | Nome: " ++ nome produto ++ " | Preço: " ++ show (preco produto) ++ " | Descrição: " ++ descricao produto ++ " | Quantidade no Estoque: " ++ show (quantidadeEstoque produto) ++ " | ID do estabelecimento: " ++ show (id_Estabelecimento produto) ++ "|\n" ++ (toStringList t)

data Produto = Produto {
    id_Produto:: Int,
    nome:: String,
    preco:: Float,
    descricao:: String,
    categoria:: String,
    quantidadeEstoque:: Int,
    id_Estabelecimento:: Int
} deriving (Show, Read, Eq)

instance FromRow Produto where
    fromRow = Produto <$> field <*> field <*> field <*> field <*> field <*> field <*> field 
