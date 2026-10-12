CREATE OR REPLACE VIEW vw_resumo AS (
    SELECT
        (SELECT COUNT(*) FROM instituicao) AS total_instituicoes,
        (SELECT COUNT(*) FROM usuario WHERE esta_ativo = true) AS usuarios_ativos,
        (SELECT COUNT(*) FROM endereco) AS total_enderecos
);
