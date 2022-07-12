{-# LANGUAGE OverloadedStrings #-}
module Main where

import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.ClienteController
import Models.Cliente


main :: IO ()
main = do

    conn <- iniciandoDatabase

    putStrLn "      +-+-+-+-+ +-+-+-+-+-+-+"
    putStrLn "      |E|a|s|y| |M|a|r|k|e|t|"
    putStrLn "      +-+-+-+-+ +-+-+-+-+-+-+"

    putStrLn " ================================= "
    putStrLn "|                                 |"
    putStrLn "|       1-  ADMINISTRADOR         |"
    putStrLn "|       2-    CLIENTE             |"
    putStrLn "|                                 |"
    putStrLn " ================================= "

    putStrLn "Digite sua opção:"
    opcao <- getLine
    let tipoDeUsuario = read opcao

    if tipoDeUsuario == 1 || tipoDeUsuario == 2
        then cadastrarOuLogar conn tipoDeUsuario
    else erro

cadastrarOuLogar:: Connection -> Int -> IO()
cadastrarOuLogar conn tipoDeUsuario = do

    putStrLn " ================================= "
    putStrLn "|       1-   CADASTRO             |"
    putStrLn "|       2-    LOGIN               |"
    putStrLn " ================================= "

    putStrLn "Digite sua opção:"
    input <- getLine
    let opcao = read input


    seletorCadastroOuLogin conn opcao tipoDeUsuario

--De acordo com a opção na função acima, é chamado uma tela/função
seletorCadastroOuLogin:: Connection -> Int -> Int -> IO()
seletorCadastroOuLogin conn 1 tipoDeUsuario = telaCadastro conn tipoDeUsuario
seletorCadastroOuLogin conn 2 tipoDeUsuario = telaLogin conn tipoDeUsuario
seletorCadastroOuLogin coon x tipoDeUsuario = erro

telaCadastro:: Connection -> Int -> IO()
telaCadastro conn tipoDeUsuario = do

    putStrLn " ================================= "
    putStrLn "|           CADASTRO               |"
    putStrLn " ================================= "

    if(tipoDeUsuario == 1) --adm
      then  putStrLn "Digite seu CNPJ:"
    else putStrLn "Digite seu CPF:"

    codigo <- getLine
    
    putStrLn "Digite seu Nome:"
    nome <- getLine
    
    putStrLn "Digite seu email:"
    email <- getLine
    
    putStrLn "Digite login:"
    login <- getLine
    
    putStrLn "Digite sua senha:"
    senha <- getLine
    
    putStrLn "Digite seu endereço, tudo em uma linha só:"
    endereco <- getLine

    putStrLn "Digite Telefone:"
    telefone <- getLine

    cadastraCliente conn nome codigo login senha endereco telefone email

    cadastrarOuLogar conn tipoDeUsuario

telaLogin:: Connection -> Int -> IO()
telaLogin conn tipoDelUsuario = do
    putStrLn " ================================= "
    putStrLn "|           LOGIN                 |"
    putStrLn " ================================= "

    putStrLn "Digite seu email:"
    email <- getLine
    
    putStrLn "Digite sua senha:"
    senha <- getLine
    if realizaLogin conn email senha then 
        putStrLn "sucesso!"
    else 
        putStrLn "Erro Login ou senha invalido"

erro::IO()
erro = do  
    putStrLn "Dado inválido"