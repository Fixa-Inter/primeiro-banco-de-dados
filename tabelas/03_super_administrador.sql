CREATE TABLE super_administrador (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);
