{-# LANGUAGE OverloadedStrings #-}
module Controllers.AdmController where
import Database.PostgreSQL.Simple
import Models.Adm

cadastraEstabelecimento::Connection -> String -> String -> String -> String -> String -> IO ()
getEstabelecimentos:: Connection -> IO [Adm]
getEstabelecimentoPorId:: Connection -> Int -> IO [Adm]
atualizaEstabelecimento::Connection -> Int -> String -> String -> String -> Int -> String -> IO ()
deletaEstabelecimento:: Connection -> Int -> IO ()
getEstabelecimentoPorLoginSenha:: Connection -> String -> String -> IO [Adm]
realizaLoginAdm:: Connection -> String -> String -> Bool


cadastraEstabelecimento conn login senha nome cnpj endereco = do
    let q = "INSERT INTO Estabelecimento (Login, Senha, Nome, CNPJ, Endereco) VALUES (?,?,?,?,?)"
    execute conn q (login, senha, nome, cnpj, endereco)
    return ()

getEstabelecimentos conn = do
    let q = "SELECT Id_Estabelecimento, Login, Nome, CNPJ, endereco From Estabelecimento;"
    query_ conn q :: IO [Adm]

getEstabelecimentoPorId conn id = do
    let q = "SELECT Id_Estabelecimento, Nome, CNPJ, endereco From Estabelecimento WHERE Id_Estabelecimento = ?;"
    query conn q (Only (id::Int)) :: IO [Adm]

getEstabelecimentoPorLoginSenha conn login senha = do
    let q = "SELECT Id_Estabelecimento, Login, Senha, Nome, CNPJ, endereco From Estabelecimento WHERE Login = ? AND Senha = ? ;"
    query conn q (login, senha) :: IO [Adm]

getTeste conn = query conn "SELECT Id_Estabelecimento, Login, Senha, Nome, CNPJ, endereco From Estabelecimento"

realizaLoginAdm conn login senha =  not (null [getEstabelecimentoPorLoginSenha conn login senha])

atualizaEstabelecimento conn id login senha nome cnpj endereco = do
    let q = "UPDATE Estabelecimento\
                \SET Login = ?,\
                \SET Senha = ?,\
                \SET Nome = ?,\
                \SET CNPJ = ?,\
                \SET endereco = ?,\
                \WHERE Id_Estabelecimento = ?;"
    execute conn q (login, senha, nome, cnpj, endereco, id)
    return ()

deletaEstabelecimento conn id = do
    let q = "DELETE FROM Estabelecimento WHERE Id_Estabelecimento = ?;"
    execute conn q (Only (id::Int))
    return ()