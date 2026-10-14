CREATE OR REPLACE VIEW vw_endereco AS
SELECT e.id, e.nome, e.rua, e.bairro, e.complemento, e.cidade, e.estado,
       e.numero, e.cep, i.nome AS instituicao_nome
FROM endereco e
JOIN instituicao i ON e.fk_instituicao_id = i.id;
