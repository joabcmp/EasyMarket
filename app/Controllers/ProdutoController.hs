{-# LANGUAGE OverloadedStrings #-}
module Controllers.ProdutoController where
import Database.PostgreSQL.Simple
import Models.Produto

cadastraProd::Connection -> String -> Float -> String -> String -> Int -> Int -> IO ()
getProds:: Connection -> IO [Produto]
getProdPorId:: Connection -> Int -> IO [Produto]
getProdPorIdEstabelecimento:: Connection -> Int -> IO [Produto]
getProdPorNome:: Connection -> String -> IO[Produto]
deletaProd:: Connection -> Int -> IO ()

cadastraProd conn nome preco descricao categoria quantidadeEstoque id_Estabelecimento = do
  let q = "INSERT INTO Produto (Nome, Preco, Descricao, Categoria, QuantidadeEstoque, Id_Estabelecimento) VALUES (?,?,?,?,?,?);"
  execute conn q (nome, preco, descricao, categoria, quantidadeEstoque,id_Estabelecimento )
  return ()

getProds conn = do
  let q = "SELECT Id_Produto, Nome, preco, Descricao, Categoria, QuantidadeEstoque, Id_Estabelecimento FROM Produto;"
  query_ conn q :: IO [Produto]

getProdPorId conn id = do
  let q = "SELECT Id_Produto, Nome, preco, Descricao, Categoria, QuantidadeEstoque, Id_Estabelecimento FROM Produto WHERE Id_Produto = ?;"
  query conn q (Only (id::Int)) :: IO [Produto]

getProdPorIdEstabelecimento conn id_estabelecimento = do
  let q = "SELECT Id_Produto, Nome, preco, Descricao, Categoria, QuantidadeEstoque,Id_Estabelecimento FROM Produto WHERE Id_Estabelecimento = ?;"
  query conn q (Only (id_estabelecimento::Int)) :: IO [Produto]

getProdPorNome conn nome = do
  let q = "SELECT Id_Produto, Nome, preco, Descricao, Categoria, QuantidadeEstoque, Id_Estabelecimento FROM Produto WHERE Nome = ?;"
  query conn q (Only (nome::String)) :: IO [Produto]

deletaProd conn id = do
    let q = "DELETE FROM Produto WHERE Id_Produto = ?;"
    execute conn q (Only (id::Int))
    return ()