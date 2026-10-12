CREATE TABLE verificacao_cadastro (
    id SERIAL PRIMARY KEY,
    codigo_verificacao VARCHAR(6) NOT NULL,
    data_expiracao TIMESTAMP DEFAULT (NOW() + INTERVAL '5 minutes'),
    email VARCHAR(100) NOT NULL,
    esta_valido BOOLEAN DEFAULT TRUE
);
