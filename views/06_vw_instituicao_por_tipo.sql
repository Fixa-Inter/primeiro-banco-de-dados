CREATE OR REPLACE VIEW vw_instituicao_por_tipo AS (
    SELECT
        tipo_instituicao,
        COUNT(*) AS total
    FROM instituicao
    GROUP BY tipo_instituicao
    ORDER BY total DESC
);
