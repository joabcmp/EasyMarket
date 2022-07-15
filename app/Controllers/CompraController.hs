{-# LANGUAGE OverloadedStrings #-}
module Controllers.CompraController where
import Database.PostgreSQL.Simple
import Models.Compra
import Models.Carrinho

cadastraCompra::Connection -> String -> String -> String -> String -> String -> IO ()
insereProdutoCarrinho::Connection->Int->Int->Int-> IO ()
getCompras:: Connection -> IO [Compra]
getCompraPorId:: Connection -> Int -> IO [Compra]
getCarrinhoPorIdCliente:: Connection -> Int -> IO [Carrinho]
deleteCarrinhoPorIdClienteIdProduto:: Connection -> Int -> Int -> IO ()
insereCompra:: Connection -> String -> Int -> Int -> IO ()
cadastraCompra conn tipoPagamento dataPagamento status totalCompra id_Cliente = do
    let q = "INSERT INTO Compra (TipoPagamento, DataPagamento, Status, TotalCompra, Id_Cliente) VALUES (?,?,?,?,?)"
    execute conn q (tipoPagamento, dataPagamento, status, totalCompra, id_Cliente)
    return ()

insereProdutoCarrinho conn id_produto id_cliente quantidade = do
    let q = "INSERT INTO Carrinho (Id_Produto, Id_Cliente, QuantidadeDoProduto) VALUES (?,?,?);"
    execute conn q (id_produto, id_cliente, quantidade)
    return ()

getCompras conn = do
    let q = "SELECT ID_Compra, TipoPagamento DataPagamento Status TotalCompra Id_Cliente From Compra;"
    query_ conn q :: IO [Compra]

getCompraPorId conn id = do
    let q = "SELECT ID_Compra, TipoPagamento DataPagamento Status TotalCompra Id_Cliente From Compra WHERE Id_Compra = ?;"
    query conn q (Only (id::Int)) :: IO [Compra]

getCarrinhoPorIdCliente conn id = do
    let q = "SELECT CA.Id_Cliente, CA.Id_Produto, CA.QuantidadeDoProduto, PR.Nome, PR.preco FROM Carrinho AS CA INNER JOIN Produto AS PR ON PR.Id_Produto = CA.Id_Produto WHERE CA.Id_Cliente = ? AND CA.ID_COMPRA IS NULL;"
    query conn q (Only (id::Int)) :: IO [Carrinho]

deleteCarrinhoPorIdClienteIdProduto conn id_cliente id_produto = do
    let q = "DELETE FROM CARRINHO WHERE ID_CLIENTE = ? AND ID_PRODUTO = ? AND ID_COMPRA IS NULL;"
    execute conn q (id_cliente, id_produto)
    return ()

insereCompra conn tipoPagamento totalCompra id_cliente = do
    let q = "INSERT INTO COMPRA (TipoPagamento, DataPagamento, TotalCompra, Id_Cliente) VALUES (?, NOW(), ?, ?);"
    execute conn q (tipoPagamento, totalCompra, id_cliente)
    
    let q = "UPDATE Produto P SET QuantidadeEstoque = QuantidadeEstoque - ? FROM Carrinho C WHERE C.Id_Produto = P.Id_Produto AND Id_Cliente = ? AND c.id_Compra IS NULL;"
    execute conn q (totalCompra, id_cliente)

    let q = "UPDATE Carrinho SET Id_Compra = 1 WHERE Id_Cliente = ? AND Id_Compra IS NULL;"
    execute conn q (id_cliente)
    return ()