CREATE OR REPLACE VIEW vw_pagamento AS
SELECT p.id, p.valor, p.data_pagamento, p.foi_realizado,
       c.status_contrato, c.data_vencimento, pl.nome AS plano_nome,
       e.estado, i.nome AS instituicao_nome,
       CASE
           WHEN p.data_pagamento > c.data_vencimento
                AND c.data_vencimento < current_date THEN false
           ELSE true
       END AS esta_em_dia
FROM pagamento p
JOIN contrato c ON p.fk_contrato_id = c.id
JOIN plano pl ON c.fk_plano_id = pl.id
JOIN endereco e ON c.fk_endereco_id = e.id
JOIN instituicao i ON e.fk_instituicao_id = i.id;
