{-# LANGUAGE OverloadedStrings #-}
module Views.MainAdm where

import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.AdmController
import Controllers.ProdutoController 
import Models.Adm
import Models.Produto as P
--TELAS DOS ADMS

mainAdm::Connection-> Int-> IO()
mainAdm conn id_estabelecimento = do

    putStrLn "             +-+-+-+"
    putStrLn "             |A|D|M|"
    putStrLn "             +-+-+-+"

    putStrLn " ==================================== "
    putStrLn "|                                    |"
    putStrLn "|       1- CADASTRAR PRODUTO         |"
    putStrLn "|       2- EXCLUIR PRODUTO           |"
    putStrLn "|       3- VER BALANÇO DE ESTOQUE    |"
    putStrLn "|       4- CLIENTES                  |"
    putStrLn "|       5- SAIR                      |"
    putStrLn "|                                    |"
    putStrLn " ==================================== "

    putStrLn "Digite sua opção:"
    input <- getLine
    let opcao = read input

    selecao conn id_estabelecimento opcao

selecao::Connection-> Int->Int->IO()
selecao conn id_estabelecimento 1 = telaCadastrarProduto  conn id_estabelecimento
selecao conn id_estabelecimento 2 = telaExcluirProduto conn id_estabelecimento
selecao conn id_estabelecimento 3 = telaBalancoEstoque conn id_estabelecimento
selecao conn id_estabelecimento 4 = telaClientes conn id_estabelecimento
selecao conn id_estabelecimento 5 = telaSair 
selecao conn id_estabelecimento x = erroAdm conn id_estabelecimento

telaCadastrarProduto:: Connection-> Int -> IO()
telaCadastrarProduto conn id_estabelecimento = do
    putStrLn " ==================================== "
    putStrLn "|        CADASTRAR PRODUTO           |"
    putStrLn " ==================================== "

    putStrLn "Digite o nome do produto:"
    nome <- getLine

    putStrLn "Digite o preço da unidade:"
    input <- getLine
    let preco = read input

    putStrLn "Digite a descrição(em uma única linha):"
    descricao <- getLine

    putStrLn "Digite a categoria:"
    categoria <- getLine

    putStrLn "Digite a quantidade:"
    input2 <- getLine
    let quantidadeEstoque = read input2

    --cadastra o produto
    cadastraProd conn nome preco descricao categoria quantidadeEstoque id_estabelecimento

    putStrLn "sucesso"

    --voltando para a tela inicial de adm
    mainAdm conn id_estabelecimento

telaExcluirProduto::Connection-> Int->IO()
telaExcluirProduto conn id_estabelecimento = do
    putStrLn " ==================================== "
    putStrLn "|        EXCLUIR PRODUTO             |"
    putStrLn " ==================================== "

    putStrLn "Qual o id do produto que você deseja excluir:"
    input <- getLine
    let identificador = read input

  
    deletaProd conn identificador
    putStrLn "Produto excluído."

    --voltando para a tela inicial de adm
    mainAdm conn id_estabelecimento

telaBalancoEstoque::Connection-> Int->IO()
telaBalancoEstoque conn id_estabelecimento = do
    putStrLn " ==================================== "
    putStrLn "|        BALANÇO DE ESTOQUE           |"
    putStrLn " ==================================== "

    putStrLn " ==================================== "
    putStrLn "|                                    |"
    putStrLn "|       1- LISTAGEM DE PRODUTOS      |"
    putStrLn "|       2- VENDAS REALIZADAS         |"
    putStrLn "|       3- DETALHAMENTO DE PRODUTO   |"
    putStrLn "|                                    |"
    putStrLn " ==================================== "

    input <- getLine
    let opcao = read input
    selecaoEstoque conn id_estabelecimento opcao

selecaoEstoque::Connection-> Int-> Int -> IO()
selecaoEstoque conn id_estabelecimento 1 = telaListagemDeProdutos  conn id_estabelecimento
selecaoEstoque conn id_estabelecimento 2 = telaVendasRealizadas conn id_estabelecimento
selecaoEstoque conn id_estabelecimento 3 = telaDetalhamentoDeProduto conn id_estabelecimento
selecaoEstoque conn id_estabelecimento x = erroAdm conn id_estabelecimento

telaListagemDeProdutos::Connection-> Int->IO()
telaListagemDeProdutos conn id_estabelecimento = do
    putStrLn " ==================================== "
    putStrLn "|        LISTAGEM DE PRODUTOS        |"
    putStrLn " ==================================== " 

    produtos <- getProdPorIdEstabelecimento conn id_estabelecimento
    
    putStrLn (P.toStringList produtos)

    --voltando para a tela inicial de adm
    mainAdm conn id_estabelecimento

telaVendasRealizadas::Connection-> Int->IO()
telaVendasRealizadas conn id_estabelecimento = do
    putStrLn " ==================================== "
    putStrLn "|        VENDAS REALIZADAS           |"
    putStrLn " ==================================== " 

    --listar as compras 

    --voltando para a tela inicial de adm
    mainAdm conn id_estabelecimento

telaDetalhamentoDeProduto::Connection-> Int->IO()
telaDetalhamentoDeProduto conn id_estabelecimento = do
    putStrLn " ==================================== "
    putStrLn "|      DETALHAMENTO DE PRODUTO       |"
    putStrLn " ==================================== " 

    putStrLn "Digite o código do produto:"
    
    id <- getLine

    produto <- getProdPorId conn (read id)

    putStrLn (P.toString (head produto))

    --voltando para a tela inicial de adm
    mainAdm conn id_estabelecimento

telaClientes::Connection-> Int->IO()
telaClientes conn id_estabelecimento = do
    putStrLn " ==================================== "
    putStrLn "|            CLIENTES                |"
    putStrLn " ==================================== "

    putStrLn " ==================================== "
    putStrLn "|                                    |"
    putStrLn "|       1- LISTAR CLIENTES           |"
    putStrLn "|       2- ACESSAR CLIENTE           |"
    putStrLn "|                                    |"
    putStrLn " ==================================== "

    putStrLn "Digite sua opção:"
    input <- getLine
    let opcao = read input

    selecaoClientes conn id_estabelecimento opcao

selecaoClientes::Connection-> Int-> Int -> IO()
selecaoClientes conn id_estabelecimento 1 = telaListagemClientes conn id_estabelecimento
selecaoClientes conn id_estabelecimento 2 = telaAcessarCliente conn id_estabelecimento
selecaoClientes conn id_estabelecimento x = erroAdm conn id_estabelecimento

telaListagemClientes::Connection->Int->IO()
telaListagemClientes conn id_estabelecimento = do
    putStrLn " ==================================== "
    putStrLn "|       LISTAGEM DE CLIENTES         |"
    putStrLn " ==================================== " 

    --listar infos dos clientes 

    --voltando para a tela inicial de adm
    mainAdm conn id_estabelecimento

telaAcessarCliente::Connection->Int->IO()
telaAcessarCliente conn id_estabelecimento = do
    putStrLn " ==================================== "
    putStrLn "|         ACESSAR CLIENTE            |"
    putStrLn " ==================================== " 

    putStrLn "Qual o id do cliente que você deseja acessar?"
    input <- getLine


    putStrLn "detalhes..."

    --voltando para a tela inicial de adm
    mainAdm conn id_estabelecimento

telaSair::IO()
telaSair = do
    putStrLn " ==================================== "
    putStrLn "|     SAINDO...ATÉ A PRÓXIMA :D      |"
    putStrLn " ==================================== "

erroAdm::Connection-> Int-> IO()
erroAdm conn id_estabelecimento = do  
    putStrLn "Dado inválido"

    --voltando para a tela inicial de adm
    mainAdm conn id_estabelecimento