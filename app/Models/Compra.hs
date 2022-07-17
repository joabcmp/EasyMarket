module Models.Compra where
import Database.PostgreSQL.Simple.FromRow

toString::Compra -> String

toString compra = "ID da compra: " ++ show (id_Compra compra) ++ "\nTipo de pagamento: " ++ tipoPagamento compra ++ "\nData de pagamento: " ++ dataPagamento compra ++  "\nTotal da compra: R$ " ++ show (totalCompra compra) ++ "\nID do cliente: " ++ show (id_Cliente compra)



data Compra = Compra {
    id_Compra:: Int,
    tipoPagamento:: String,
    dataPagamento:: String, 
    totalCompra:: Float,
    id_Cliente:: Int
} deriving (Show, Read, Eq)

instance FromRow Compra where
    fromRow = Compra <$> field <*> field <*> field <*> field <*> field 