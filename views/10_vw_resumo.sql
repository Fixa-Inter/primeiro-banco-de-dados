CREATE OR REPLACE VIEW vw_resumo AS (
    SELECT
        (SELECT COUNT(*) FROM instituicao) AS total_instituicoes,
        (SELECT COUNT(*) FROM usuario) AS total_usuarios,
        (SELECT COUNT(*) FROM endereco) AS total_enderecos
);
