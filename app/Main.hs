{-# LANGUAGE OverloadedStrings #-}
module Main where

import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.ClienteController
import Models.Cliente

main :: IO ()
main = do
    putStrLn "Criando base de dados..."
    conn <- iniciandoDatabase
    putStrLn "Base de dados criada"
    
    clientes <- getClientePorId conn 1
    
    putStrLn  (toString (head clientes))