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
