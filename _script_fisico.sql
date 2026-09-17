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
    nome VARCHAR(50),
    esta_ativo BOOLEAN DEFAULT true,
    email_corporativo VARCHAR(50),
    data_cadastro DATE DEFAULT current_date,
    dominio_email VARCHAR(100) UNIQUE
);
 
CREATE TABLE plano (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50),
    valor_mensal DECIMAL(10,2) NOT NULL CHECK (valor_mensal > -1),
    duracao_meses INTEGER,
    descricao VARCHAR(255),
    data_criacao TIMESTAMP DEFAULT NOW(),

    CONSTRAINT ck_plano_duracao
        CHECK (duracao_meses > 0)
);
 
CREATE TABLE metodo_pagamento (
    id SERIAL PRIMARY KEY,
    descricao TEXT
);
 
CREATE TABLE super_administrador (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    senha_hash VARCHAR(255),
    email VARCHAR(100) UNIQUE
);
 
CREATE TABLE contrato (
    id SERIAL PRIMARY KEY,
    data_inicio DATE DEFAULT current_date,
    data_vencimento DATE,
    fk_plano_id INTEGER,
    esta_vigente BOOLEAN DEFAULT true,
    fk_endereco_id INTEGER,
    data_criacao TIMESTAMP DEFAULT NOW(),

    FOREIGN KEY (fk_plano_id)
        REFERENCES plano(id),

    FOREIGN KEY (fk_endereco_id)
        REFERENCES endereco(id),

    CONSTRAINT ck_contrato_datas
        CHECK (data_vencimento > data_inicio)
);
 
CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    senha_hash VARCHAR(255),
    esta_ativo BOOLEAN DEFAULT FALSE,
    email VARCHAR(100) NOT NULL,
    data_criacao DATE DEFAULT current_date,
    cargo VARCHAR(50),
    tipo_de_acesso VARCHAR(20),
    fk_endereco_id INTEGER,
    data_nascimento DATE,
    primeiro_acesso BOOLEAN DEFAULT TRUE,

    CONSTRAINT uk_email
        UNIQUE (email),

    FOREIGN KEY (fk_endereco_id)
        REFERENCES endereco(id)
);
 
CREATE TABLE endereco (
    id SERIAL PRIMARY KEY,
    rua VARCHAR(40),
    bairro VARCHAR(40),
    complemento VARCHAR(50),
    cidade VARCHAR(40),
    estado CHAR(2),
    numero VARCHAR(10),
    cep CHAR(8),
    fk_instituicao_id INTEGER,
    cnpj CHAR(14) UNIQUE,
    data_criacao TIMESTAMP DEFAULT NOW(),

    FOREIGN KEY (fk_instituicao_id)
        REFERENCES instituicao(id)
);
 
CREATE TABLE pagamento (
    id SERIAL PRIMARY KEY,
    valor DECIMAL(10,2) CHECK (valor > -1),
    data_pagamento TIMESTAMP DEFAULT current_timestamp,
    foi_realizado BOOLEAN DEFAULT false,
    fk_contrato_id INTEGER,
    fk_metodo_pagamento_id INTEGER,
    data_criacao TIMESTAMP DEFAULT NOW(),

    FOREIGN KEY (fk_contrato_id)
        REFERENCES contrato(id),

    FOREIGN KEY (fk_metodo_pagamento_id)
        REFERENCES metodo_pagamento(id)
);
 
CREATE TABLE foto_usuario (
    id SERIAL PRIMARY KEY,
    data_registro TIMESTAMP DEFAULT NOW(),
    url VARCHAR(255),
    fk_usuario_id INTEGER,

    FOREIGN KEY (fk_usuario_id)
        REFERENCES usuario(id)
);