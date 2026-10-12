CREATE TABLE foto_usuario (
    id SERIAL PRIMARY KEY,
    data_registro TIMESTAMP DEFAULT NOW(),
    url VARCHAR(255),
    fk_usuario_id INTEGER,
    FOREIGN KEY (fk_usuario_id)
        REFERENCES usuario(id) ON DELETE CASCADE
);
