CREATE OR REPLACE VIEW vw_endereco_por_instituicao AS (
    SELECT
        i.nome AS instituicao_nome,
        COUNT(e.id) AS total_enderecos,
        ROUND(COUNT(e.id) * 100.0 / (SELECT COUNT(*) FROM endereco), 0) AS percentual
    FROM endereco e
    JOIN instituicao i ON e.fk_instituicao_id = i.id
    GROUP BY i.nome
    ORDER BY total_enderecos DESC
    LIMIT 4
);
