{-# LANGUAGE OverloadedStrings #-}
module Views.MainCliente where

import Database.PostgreSQL.Simple
import Models.Produto as P
import Models.Carrinho as C
import Controllers.ProdutoController
import Controllers.CompraController
mainCliente::Connection->Int->IO()
mainCliente conn id_cliente= do
    putStrLn "         +-+-+-+-+-+-+-+"
    putStrLn "         |C|L|I|E|N|T|E|"
    putStrLn "         +-+-+-+-+-+-+-+"

    putStrLn " ==================================== "
    putStrLn "|                                    |"
    putStrLn "|       1- LISTAGEM DE PRODUTOS      |"
    putStrLn "|       2- VER CARRINHO ATUAL        |"
    putStrLn "|       3- VER PERFIL                |"
    putStrLn "|       4- SAIR                      |"
    putStrLn "|                                    |"
    putStrLn " ==================================== "

    putStrLn "Digite sua opção:"
    input <- getLine
    let opcao = read input
    selecao conn id_cliente opcao

selecao:: Connection->Int->Int -> IO()
selecao conn id_cliente 1 = telaListagemDeProdutos conn id_cliente
selecao conn id_cliente 2 = telaCarrinhoAtual conn id_cliente
selecao conn id_cliente 3 = telaPerfil conn id_cliente
selecao conn id_cliente 4 = telaSair  
selecao conn id_cliente x = erroCliente conn id_cliente

telaListagemDeProdutos:: Connection->Int->IO()
telaListagemDeProdutos conn id_cliente = do
    putStrLn " ==================================== "
    putStrLn "|        LISTAGEM DE PRODUTOS        |"
    putStrLn " ==================================== "

    produtos <- getProds conn

    putStrLn (P.toStringList produtos)

    putStrLn "Qual produto deseja comprar?digite o id do produto:"
    putStrLn "OBS:Digite -1 para ir para o carrinho ou -2 para voltar à tela inicial."

    input <- getLine
    let idProduto = read input

    lerProdutos conn id_cliente idProduto

lerProdutos::Connection->Int-> Int -> IO()
lerProdutos conn id_cliente (-1) = telaCarrinhoAtual conn id_cliente
lerProdutos conn id_cliente (-2) = mainCliente conn id_cliente
lerProdutos conn id_cliente id_produto = do
    --adicionar o produto no carrinho da compra do cliente
    putStrLn "Informe a quantidade de produtos desejados:"
    quantidade <- getLine

    insereProdutoCarrinho conn id_produto id_cliente (read quantidade)

    putStrLn "Produto adicionado."
    
    produtos <- getProds conn
    putStrLn (P.toStringList produtos)

    putStrLn "Qual produto deseja comprar?digite o id do produto:"
    putStrLn "OBS:Digite -1 para ir para o carrinho ou -2 para voltar à tela inicial."
    opcao <- getLine
    let idProximoProduto = read opcao

    lerProdutos conn id_cliente idProximoProduto --adicionar o novo produto informado
    --essa função só para de ler os produtos quando o usuário informa se quer ir para o carrinho ou voltar à tela inicial


telaCarrinhoAtual::Connection->Int->IO()
telaCarrinhoAtual conn id_cliente = do
    putStrLn " ==================================== "
    putStrLn "|        CARRINHO DE COMPRAS         |"
    putStrLn " ==================================== "

    carrinho <- getCarrinhoPorIdCliente conn id_cliente

    putStrLn (C.toString carrinho)

    --EXIBE OS PRODUTOS

    putStrLn "Deseja excluir algum produto(digite o id)?(S/N)"
    op <- getLine 

    if(op `elem` ["S","s","SIM","sim","Sim"])
        then do
            putStrLn "Digite o id do produto que deseja excluir:"
            input <- getLine
            
            deleteCarrinhoPorIdClienteIdProduto conn id_cliente (read input)
            
            putStrLn "Produto excluído."
            
            telaCarrinhoAtual conn id_cliente
    else do
        putStrLn "Deseja finalizar a compra?(S/N)"
        opcao <- getLine

        if(opcao `elem` ["S","s","SIM","sim","Sim"])
            then telaFinalizarCompra conn id_cliente
        else 
            mainCliente conn id_cliente


telaFinalizarCompra::Connection->Int->IO()
telaFinalizarCompra conn id_cliente= do

    putStrLn " ==================================== "
    putStrLn "|       FINALIZANDO COMPRA...        |"
    putStrLn " ==================================== "

    putStrLn "Informe o tipo de pagamento:(cartão/em espécie/PIX)"
    tipoDePagamento <- getLine

    insereCompra conn tipoDePagamento 10 id_cliente

    putStrLn "..."
    putStrLn "Compra finalizada."

    --putStrLn " ==================================== "
    --putStrLn "|        DETALHES DA COMPRA          |"
    --putStrLn " ==================================== "

    --exibir detalhes da comprar:produtos + preço final + tipo de pagamento + status finalizado

    putStrLn " ============================================= "
    putStrLn "  Deseja voltar à tela inicial(0) ou sair(1)?"
    input <- getLine
    let opcao = read input

    telaVoltarAInicialOuSair conn id_cliente opcao

telaPerfil::Connection->Int->IO()
telaPerfil conn id_cliente = do
    putStrLn " ==================================== "
    putStrLn "|        PERFIL DO CLIENTE           |"
    putStrLn " ==================================== "

    --exibir dados de cadastro e uma lista das compras realizadas?o que tiver mais fácil :) ou menos
    --difícil

    putStrLn " ============================================= "
    putStrLn "Deseja voltar à tela inicial(0) ou sair(1)?"
    input <- getLine
    let opcao = read input

    telaVoltarAInicialOuSair conn id_cliente opcao

telaVoltarAInicialOuSair::Connection->Int->Int -> IO()
telaVoltarAInicialOuSair conn id_cliente 0 = mainCliente conn id_cliente
telaVoltarAInicialOuSair conn id_cliente 1 = telaSair
telaVoltarAInicialOuSair conn id_cliente x = erroCliente conn id_cliente


telaSair::IO()
telaSair = do
    putStrLn " ==================================== "
    putStrLn "|     SAINDO...ATÉ A PRÓXIMA :D      |"
    putStrLn " ==================================== "

erroCliente::Connection->Int-> IO()
erroCliente conn id_cliente = do  
    putStrLn "Dado inválido :("

    --voltando para a tela inicial de adm
    mainCliente conn id_cliente