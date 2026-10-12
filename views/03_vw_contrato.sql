CREATE OR REPLACE VIEW vw_contrato AS
SELECT c.id, c.data_inicio, c.data_vencimento, c.status_contrato,
       p.nome AS plano_nome, e.estado, i.nome AS instituicao_nome
FROM contrato c
JOIN plano p ON c.fk_plano_id = p.id
JOIN endereco e ON c.fk_endereco_id = e.id
JOIN instituicao i ON e.fk_instituicao_id = i.id;
