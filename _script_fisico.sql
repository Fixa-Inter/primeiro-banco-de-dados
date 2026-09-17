-- Drop tables
DROP TABLE IF EXISTS foto_usuario;
DROP TABLE IF EXISTS pagamento;
DROP TABLE IF EXISTS endereco;
DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS contrato;
DROP TABLE IF EXISTS super_administrador;
DROP TABLE IF EXISTS metodo_pagamento;
DROP TABLE IF EXISTS plano;
DROP TABLE IF EXISTS instituicao;
DROP TABLE IF EXISTS tipo_instituicao;

-- Create tables
CREATE TABLE instituicao (
    id SERIAL PRIMARY KEY,
    nome VARCHAR (50),
    esta_ativo BOOLEAN DEFAULT true,
    email_corporativo VARCHAR (50),
    data_cadastro DATE DEFAULT current_date,
    cnpj VARCHAR (14)
);
 
CREATE TABLE plano (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50),
    valor_mensal FLOAT NOT NULL CHECK (valor_mensal > -1),
    duracao_meses INTEGER CHECK (valor_mensal > -1),
    descricao TEXT
);
 
CREATE TABLE metodo_pagamento (
    id SERIAL PRIMARY KEY,
    descricao TEXT
);
 
CREATE TABLE super_administrador (
    id SERIAL PRIMARY KEY,
    funcao VARCHAR(50),
    nome VARCHAR(50),
    senha_hash VARCHAR(64),
    email VARCHAR(50) UNIQUE
);
 
CREATE TABLE contrato (
    id SERIAL PRIMARY KEY,
    data_inicio DATE DEFAULT current_date,
    data_vencimento DATE,
    fk_plano_id INTEGER,
    esta_vigente BOOLEAN DEFAULT true,

    FOREIGN KEY (fk_plano_id)
        REFERENCES plano(id)
);
 
CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    senha_hash VARCHAR(64),
    esta_ativo BOOLEAN DEFAULT true,
    email VARCHAR(50) UNIQUE,
    data_criacao DATE DEFAULT current_date,
    cargo VARCHAR(50),
    fk_instituicao_id INTEGER,
    tipo_de_acesso VARCHAR(20),
    data_ultimo_acesso DATE DEFAULT current_date,

    FOREIGN KEY (fk_instituicao_id)
        REFERENCES instituicao(id)
);
 
CREATE TABLE endereco (
    id SERIAL PRIMARY KEY,
    rua VARCHAR(40),
    bairro VARCHAR(40),
    complemento VARCHAR(50),
    cidade VARCHAR(40),
    estado VARCHAR(40),
    numero INTEGER,
    cep VARCHAR(9),
    fk_instituicao_id INTEGER,
    cnpj CHAR(14) UNIQUE,

    FOREIGN KEY (fk_instituicao_id)
        REFERENCES instituicao(id)
);
 
CREATE TABLE pagamento (
    id SERIAL PRIMARY KEY,
    valor FLOAT CHECK (valor > -1),
    data_pagamento TIMESTAMP DEFAULT current_timestamp,
    foi_realizado BOOLEAN DEFAULT false,
    fk_contrato_id INTEGER,
    fk_metodo_pagamento_id INTEGER,
 
    FOREIGN KEY (fk_contrato_id)
        REFERENCES contrato(id),
 
    FOREIGN KEY (fk_metodo_pagamento_id)
        REFERENCES metodo_pagamento(id)
);
 
CREATE TABLE foto_usuario (
    id SERIAL PRIMARY KEY,
    data_registro DATE DEFAULT current_date,
    url VARCHAR (250),
    fk_usuario_id INTEGER,
 
    FOREIGN KEY (fk_usuario_id)
        REFERENCES usuario(id)
);