-- Drop tables
DROP TABLE IF EXISTS foto_usuario CASCADE;
DROP TABLE IF EXISTS pagamento CASCADE;
DROP TABLE IF EXISTS usuario CASCADE;
DROP TABLE IF EXISTS contrato CASCADE;
DROP TABLE IF EXISTS endereco CASCADE;
DROP TABLE IF EXISTS super_administrador CASCADE;
DROP TABLE IF EXISTS plano CASCADE;
DROP TABLE IF EXISTS instituicao CASCADE;


-- Create tables

CREATE TABLE instituicao (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    email_corporativo VARCHAR(50) UNIQUE NOT NULL,
    data_cadastro DATE DEFAULT current_date,
    dominio_email VARCHAR(100) UNIQUE,
    tipo_instituicao INTEGER NOT NULL,
    senha_hash VARCHAR(255) NOT NULL
);


CREATE TABLE plano (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50),
    valor_mensal DECIMAL(10,2) NOT NULL CHECK (valor_mensal > -1),
    duracao_meses INTEGER NOT NULL CHECK (duracao_meses > 0),
    descricao VARCHAR(255),
    data_criacao TIMESTAMP DEFAULT NOW(),

    CONSTRAINT ck_plano_duracao
        CHECK (duracao_meses > 0)
);


CREATE TABLE super_administrador (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);


CREATE TABLE endereco (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
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
        REFERENCES instituicao(id) ON DELETE CASCADE
);


CREATE TABLE contrato (
    id SERIAL PRIMARY KEY,
    data_inicio DATE DEFAULT current_date,
    data_vencimento DATE,
    fk_plano_id INTEGER,
    fk_endereco_id INTEGER,
    status_contrato INTEGER NOT NULL,
    data_criacao TIMESTAMP DEFAULT NOW(),

    FOREIGN KEY (fk_plano_id)
        REFERENCES plano(id) ON DELETE CASCADE,

    FOREIGN KEY (fk_endereco_id)
        REFERENCES endereco(id) ON DELETE CASCADE,

    CONSTRAINT ck_contrato_datas
        CHECK (data_vencimento > data_inicio)
);


CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    esta_ativo BOOLEAN DEFAULT FALSE,
    email VARCHAR(100) UNIQUE NOT NULL,
    data_criacao TIMESTAMP DEFAULT NOW(),
    cargo VARCHAR(50),
    tipo_acesso INTEGER NOT NULL,
    fk_endereco_id INTEGER,
    data_nascimento DATE,
    primeiro_acesso BOOLEAN DEFAULT TRUE,


    FOREIGN KEY (fk_endereco_id)
        REFERENCES endereco(id) ON DELETE CASCADE
);


CREATE TABLE pagamento (
    id SERIAL PRIMARY KEY,
    valor DECIMAL(10,2) CHECK (valor > -1),
    data_pagamento TIMESTAMP DEFAULT current_timestamp,
    foi_realizado BOOLEAN DEFAULT false,
    fk_contrato_id INTEGER,
    metodo_pagamento INTEGER NOT NULL,
    data_criacao TIMESTAMP DEFAULT NOW(),

    FOREIGN KEY (fk_contrato_id)
        REFERENCES contrato(id) ON DELETE CASCADE
);


CREATE TABLE foto_usuario (
    id SERIAL PRIMARY KEY,
    data_registro TIMESTAMP DEFAULT NOW(),
    url VARCHAR(255),
    fk_usuario_id INTEGER,

    FOREIGN KEY (fk_usuario_id)
        REFERENCES usuario(id) ON DELETE CASCADE
);

CREATE TABLE verificacao_cadastro (
    id SERIAL PRIMARY KEY,
    codigo_verificacao VARCHAR(6) NOT NULL,
    data_expiracao TIMESTAMP DEFAULT (NOW() + INTERVAL '5 minutes'),
    email VARCHAR(100) NOT NULL,
    esta_valido BOOLEAN DEFAULT TRUE
);


-- Create views
CREATE OR REPLACE VIEW vw_usuario AS (
    SELECT u.id, u.nome, u.email, u.cargo, u.tipo_acesso, u.esta_ativo, u.data_nascimento, u.primeiro_acesso, e.nome AS endereco_nome, e.estado, i.nome AS instituicao_nome
    FROM usuario u
    JOIN endereco e ON u.fk_endereco_id = e.id
    JOIN instituicao i ON e.fk_instituicao_id = i.id
);

CREATE OR REPLACE VIEW vw_endereco AS (
    SELECT e.id, e.nome, e.rua, e.bairro, e.complemento, e.cidade, e.estado, e.numero, e.cep, i.nome AS instituicao_nome
    FROM endereco e
    JOIN instituicao i ON e.fk_instituicao_id = i.id
);

CREATE OR REPLACE VIEW vw_contrato AS (
    SELECT c.id, c.data_inicio, c.data_vencimento, c.status_contrato, p.nome AS plano_nome, e.nome AS endereco_nome, e.estado, i.nome AS instituicao_nome
    FROM contrato c
    JOIN plano p ON c.fk_plano_id = p.id
    JOIN endereco e ON c.fk_endereco_id = e.id
    JOIN instituicao i ON e.fk_instituicao_id = i.id
);

CREATE OR REPLACE VIEW vw_pagamento AS (
    SELECT p.id, p.valor, p.data_pagamento, p.foi_realizado, c.status_contrato, c.data_vencimento, pl.nome AS plano_nome, e.nome AS endereco_nome, e.estado, i.nome AS instituicao_nome,
        CASE
        WHEN p.data_pagamento > c.data_vencimento AND c.data_vencimento < current_date THEN false
        ELSE true
        END AS esta_em_dia
    FROM pagamento p
    JOIN contrato c ON p.fk_contrato_id = c.id
    JOIN plano pl ON c.fk_plano_id = pl.id
    JOIN endereco e ON c.fk_endereco_id = e.id
    JOIN instituicao i ON e.fk_instituicao_id = i.id
);

CREATE OR REPLACE VIEW vw_foto_usuario AS (
    SELECT f.id, f.data_registro, f.url, u.nome AS usuario_nome, u.email AS usuario_email
    FROM foto_usuario f
    JOIN usuario u ON f.fk_usuario_id = u.id
);

CREATE OR REPLACE VIEW vw_instituicao_por_tipo AS (
    SELECT
        tipo_instituicao,
        COUNT(*) AS total
        ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM instituicao), 0) AS percentual
    FROM instituicao
    GROUP BY tipo_instituicao
    ORDER BY total DESC
);

CREATE OR REPLACE VIEW vw_usuario_por_atividade AS (
    SELECT
        esta_ativo,
        COUNT(*) AS total
        ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM usuario), 0) AS percentual
    FROM usuario
    GROUP BY esta_ativo
    ORDER BY total DESC
);

CREATE OR REPLACE VIEW vw_contrato_por_plano AS (
    SELECT
        p.nome AS plano_nome,
        COUNT(c.id) AS total_contratos
        ROUND(COUNT(c.id) * 100.0 / (SELECT COUNT(*) FROM contrato), 0) AS percentual
    FROM contrato c
    JOIN plano p ON c.fk_plano_id = p.id
    GROUP BY p.nome
    ORDER BY total_contratos DESC
);

CREATE OR REPLACE VIEW vw_endereco_por_instituicao AS (
    SELECT
        i.nome AS instituicao_nome,
        COUNT(e.id) AS total_enderecos
        ROUND(COUNT(e.id) * 100.0 / (SELECT COUNT(*) FROM endereco), 0) AS percentual
    FROM endereco e
    JOIN instituicao i ON e.fk_instituicao_id = i.id
    GROUP BY i.nome
    ORDER BY total_enderecos DESC
);

CREATE OR REPLACE VIEW vw_resumo AS(
    SELECT
    (SELECT COUNT(*) FROM instituicao) AS total_instituicoes,
    (SELECT COUNT(*) FROM usuario) AS total_usuarios,
    (SELECT COUNT(*) FROM endereco) AS total_enderecos
);
