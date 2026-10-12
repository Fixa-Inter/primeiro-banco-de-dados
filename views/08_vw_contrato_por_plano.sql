CREATE OR REPLACE VIEW vw_contrato_por_plano AS (
    SELECT
        p.nome AS plano_nome,
        COUNT(c.id) AS total_contratos
    FROM contrato c
    JOIN plano p ON c.fk_plano_id = p.id
    GROUP BY p.nome
    ORDER BY total_contratos DESC
);
