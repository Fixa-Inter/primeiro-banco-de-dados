CREATE OR REPLACE VIEW vw_usuario AS
SELECT u.id, u.nome, u.email, u.cargo, u.tipo_acesso, u.esta_ativo,
       u.data_nascimento, u.primeiro_acesso, e.estado,
       i.nome AS instituicao_nome
FROM usuario u
JOIN endereco e ON u.fk_endereco_id = e.id
JOIN instituicao i ON e.fk_instituicao_id = i.id;
