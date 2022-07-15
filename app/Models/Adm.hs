module Models.Adm where
import Database.PostgreSQL.Simple.FromRow

  --  Id_Estabelecimento SERIAL PRIMARY KEY,\
  --  Login              VARCHAR(30),\
  --  Senha              VARCHAR,\
  --  Nome               CHAR(20),\
  --  CNPJ               CHAR(14),\
  --  Endereço           VARCHAR(100)\

toStringEstabelecimento::Adm -> String

toStringEstabelecimento estabelecimento = "ID do Estabelecimento: " ++ show (id_Estabelecimento estabelecimento)  ++ "\nLogin: " ++ login estabelecimento ++ "\nSenha: " ++ senha estabelecimento ++ "\nNome: " ++ nome estabelecimento ++ "\nCNPJ: " ++ cnpj estabelecimento ++ "\nEndereço: " ++ endereco estabelecimento

data Adm = Adm {
    id_Estabelecimento:: Int,
    login:: String,
    senha:: String,
    nome:: String,
    cnpj:: String,
    endereco:: String
} deriving (Show, Read, Eq)

instance FromRow Adm where
    fromRow = Adm <$> field <*> field <*> field <*> field <*> field <*> field