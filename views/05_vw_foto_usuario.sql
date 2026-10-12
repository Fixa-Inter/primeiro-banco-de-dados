CREATE OR REPLACE VIEW vw_foto_usuario AS
SELECT f.id, f.data_registro, f.url,
       u.nome AS usuario_nome, u.email AS usuario_email
FROM foto_usuario f
JOIN usuario u ON f.fk_usuario_id = u.id;
