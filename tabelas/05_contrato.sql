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
    CONSTRAINT ck_contrato_datas CHECK (data_vencimento > data_inicio)
);
