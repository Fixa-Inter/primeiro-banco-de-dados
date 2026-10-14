CREATE OR REPLACE VIEW vw_usuario_por_atividade AS (
    SELECT
        esta_ativo,
        COUNT(*) AS total,
        ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM usuario), 0) AS percentual
    FROM usuario
    GROUP BY esta_ativo
    ORDER BY total DESC
);
