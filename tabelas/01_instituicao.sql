CREATE TABLE instituicao (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    email_corporativo VARCHAR(50) UNIQUE NOT NULL,
    data_cadastro DATE DEFAULT current_date,
    dominio_email VARCHAR(100) UNIQUE,
    tipo_instituicao INTEGER NOT NULL,
    senha_hash VARCHAR(255) NOT NULL
);
