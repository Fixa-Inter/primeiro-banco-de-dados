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
        REFERENCES instituicao(id) ON DELETE CASCADE
);
