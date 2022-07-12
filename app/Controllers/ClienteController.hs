{-# LANGUAGE OverloadedStrings #-}
module Controllers.ClienteController where
import Database.PostgreSQL.Simple
import Models.Cliente

cadastraCliente::Connection -> String -> String -> String -> String -> String -> String -> String -> IO ()
getClientes:: Connection -> IO [Cliente]
getClientePorId:: Connection -> Int -> IO [Cliente]
atualizaCliente::Connection -> Int -> String -> String -> String -> String -> String -> String -> String -> IO ()
deletaCliente:: Connection -> Int -> IO ()
getClientePorLoginSenha:: Connection -> String -> String -> IO [Cliente]
realizaLogin:: Connection -> String -> String -> Bool

cadastraCliente conn nome cpf login senha endereco telefone email = do
    let q = "INSERT INTO Cliente (Nome, CPF, Login, Senha, Endereco, Telefone, Email) VALUES (?,?,?,?,?,?,?)"
    execute conn q (nome, cpf, login, senha, endereco, telefone, email)
    return ()

getClientes conn = do
    let q = "SELECT Id_Cliente, Nome, CPF, Login, Senha, Endereco, Telefone, Email From Cliente;"
    query_ conn q :: IO [Cliente]

getClientePorId conn id = do
    let q = "SELECT Id_Cliente, Nome, CPF, Login, Senha, Endereco, Telefone, Email From Cliente WHERE Id_Cliente = ?;"
    query conn q (Only (id::Int)) :: IO [Cliente]

getClientePorLoginSenha conn login senha = do
    let q = "SELECT Id_Cliente, Nome, CPF, Login, Senha, Endereco, Telefone, Email From Cliente WHERE Login = ? AND Senha = ? ;"
    query conn q (login, senha) :: IO [Cliente]

realizaLogin conn login senha =  length [getClientePorLoginSenha conn login senha] /= 0

atualizaCliente conn id nome cpf login senha endereco telefone email = do
    let q = "UPDATE Cliente\
                \SET Nome = ?,\
                \SET CPF = ?,\
                \SET Login = ?,\
                \SET Senha = ?,\
                \SET Endereco = ?,\
                \SET Telefone = ?,\
                \SET Email = ?\
                \WHERE Id_Cliente = ?;"
    execute conn q (nome, cpf, login, senha, endereco, telefone, email, id)
    return ()

deletaCliente conn id = do
    let q = "DELETE FROM CLIENTE WHERE ID_CLIENTE = ?;"
    execute conn q (Only (id::Int))
    return ()
