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
