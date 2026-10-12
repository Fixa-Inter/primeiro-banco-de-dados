CREATE OR REPLACE VIEW vw_usuario_por_atividade AS (
    SELECT
        esta_ativo,
        COUNT(*) AS total
    FROM usuario
    GROUP BY esta_ativo
    ORDER BY total DESC
);
