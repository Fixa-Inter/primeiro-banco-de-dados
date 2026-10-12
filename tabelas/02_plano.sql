CREATE TABLE plano (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50),
    valor_mensal DECIMAL(10,2) NOT NULL CHECK (valor_mensal > -1),
    duracao_meses INTEGER NOT NULL CHECK (duracao_meses > 0),
    descricao VARCHAR(255),
    data_criacao TIMESTAMP DEFAULT NOW(),
    CONSTRAINT ck_plano_duracao CHECK (duracao_meses > 0)
);
