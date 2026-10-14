CREATE OR REPLACE VIEW vw_instituicao_por_tipo AS (
    SELECT
        tipo_instituicao,
        COUNT(*) AS total,
        ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM instituicao), 0) AS percentual
    FROM instituicao
    GROUP BY tipo_instituicao
    ORDER BY total DESC
);
