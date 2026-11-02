-- =====================================================================
-- DATALOAD
-- Executar DEPOIS do script de criação das tabelas/views.
--
-- Senhas (SHA-256 em Base64) - senhas em texto puro, apenas para teste:
--   Super@123       -> super_administrador
--   Inst@123        -> instituicao
--   Admin@123       -> usuario tipo_acesso 1 (Administrador)
--   Gestor@123      -> usuario tipo_acesso 2 (Gestor)
--   Tecnico@123     -> usuario tipo_acesso 3 (Técnico)
--   Solicitante@123 -> usuario tipo_acesso 4 (Solicitante)
--
-- Domínios de valores:
--   instituicao.tipo_instituicao : 1=Escola 2=Faculdade 3=Empresa 4=Órgão Público
--   contrato.status_contrato     : 1=Ativo 2=Inativo 3=Cancelado
--   usuario.tipo_acesso          : 1=Administrador 2=Gestor 3=Técnico 4=Solicitante
--   pagamento.metodo_pagamento   : 1=Crédito 2=Débito 3=Pix
-- =====================================================================
 
-- Limpa os dados existentes e reinicia as sequências (ordem respeita as FKs)
TRUNCATE TABLE
    verificacao_cadastro,
    foto_usuario,
    pagamento,
    usuario,
    contrato,
    endereco,
    super_administrador,
    plano,
    instituicao
RESTART IDENTITY CASCADE;
 
 
-- ---------------------------------------------------------------------
-- instituicao (4 registros, um de cada tipo)
-- ---------------------------------------------------------------------
INSERT INTO instituicao (id, nome, email_corporativo, data_cadastro, dominio_email, tipo_instituicao, senha_hash) VALUES
(1, 'Colégio Horizonte',        'contato@colegiohorizonte.com.br', '2026-01-10', 'colegiohorizonte.com.br', 1, 'KUGqq9Di5/J8yhE7l3CFWDbevp5Lqj54yzOmu4nAeys='),
(2, 'Faculdade Nova Era',       'contato@faculdadenovaera.edu.br', '2026-02-15', 'faculdadenovaera.edu.br', 2, 'KUGqq9Di5/J8yhE7l3CFWDbevp5Lqj54yzOmu4nAeys='),
(3, 'TechSul Soluções',         'contato@techsul.com.br',          '2026-03-20', 'techsul.com.br',          3, 'KUGqq9Di5/J8yhE7l3CFWDbevp5Lqj54yzOmu4nAeys='),
(4, 'Prefeitura de Vila Verde', 'contato@vilaverde.sp.gov.br',     '2026-04-05', 'vilaverde.sp.gov.br',     4, 'KUGqq9Di5/J8yhE7l3CFWDbevp5Lqj54yzOmu4nAeys=');
 
 
-- ---------------------------------------------------------------------
-- plano (4 registros)
-- ---------------------------------------------------------------------
INSERT INTO plano (id, nome, valor_mensal, duracao_meses, descricao) VALUES
(1, 'Básico',       199.90,  6, 'Plano básico com recursos essenciais e suporte por e-mail.'),
(2, 'Intermediário', 399.90, 12, 'Plano intermediário com relatórios e suporte em horário comercial.'),
(3, 'Premium',       799.90, 12, 'Plano completo com suporte 24h e relatórios avançados.'),
(4, 'Enterprise',  1499.90, 24, 'Plano corporativo com atendimento dedicado e integrações.');
 
 
-- ---------------------------------------------------------------------
-- super_administrador (3 registros)
-- ---------------------------------------------------------------------
INSERT INTO super_administrador (id, nome, senha_hash, email) VALUES
(1, 'Miguel Yuji',    'kQptzd1g3QanoryoTcLPsOxV3T3sVcGcWOsshr2GqSs=', 'miguel.yuji@plataforma.com.br'),
(2, 'Ana Beatriz Lima', 'kQptzd1g3QanoryoTcLPsOxV3T3sVcGcWOsshr2GqSs=', 'ana.lima@plataforma.com.br'),
(3, 'Carlos Eduardo Souza', 'kQptzd1g3QanoryoTcLPsOxV3T3sVcGcWOsshr2GqSs=', 'carlos.souza@plataforma.com.br');
 
 
-- ---------------------------------------------------------------------
-- endereco (6 registros; algumas instituições possuem mais de uma unidade)
-- ---------------------------------------------------------------------
INSERT INTO endereco (id, nome, rua, bairro, complemento, cidade, estado, numero, cep, fk_instituicao_id, cnpj) VALUES
(1, 'Unidade Centro',     'Rua das Palmeiras',        'Centro',        'Bloco A',    'São Paulo',      'SP', '120',  '01001000', 1, '11222333000181'),
(2, 'Unidade Zona Sul',   'Avenida Santo Amaro',      'Santo Amaro',   NULL,         'São Paulo',      'SP', '4500', '04702000', 1, '11222333000262'),
(3, 'Campus Principal',   'Avenida Paulista',         'Bela Vista',    'Torre 2',    'São Paulo',      'SP', '1578', '01310200', 2, '22333444000172'),
(4, 'Sede Administrativa','Rua XV de Novembro',       'Centro',        'Sala 301',   'Curitiba',       'PR', '850',  '80020310', 3, '33444555000163'),
(5, 'Filial Campinas',    'Avenida Brasil',           'Cambuí',        NULL,         'Campinas',       'SP', '2200', '13025000', 3, '33444555000244'),
(6, 'Paço Municipal',     'Praça da República',       'Centro',        NULL,         'Vila Verde',     'SP', '1',    '06010000', 4, '44555666000154');
 
 
-- ---------------------------------------------------------------------
-- contrato (6 registros, com status variados)
-- ---------------------------------------------------------------------
INSERT INTO contrato (id, data_inicio, data_vencimento, fk_plano_id, fk_endereco_id, status_contrato) VALUES
(1, '2026-01-15', '2026-07-15', 1, 1, 2),  -- Inativo (expirado)
(2, '2026-03-01', '2027-03-01', 2, 2, 1),  -- Ativo
(3, '2026-02-20', '2027-02-20', 3, 3, 1),  -- Ativo
(4, '2026-04-10', '2028-04-10', 4, 4, 1),  -- Ativo
(5, '2026-05-05', '2026-11-05', 1, 5, 3),  -- Cancelado
(6, '2026-06-01', '2027-06-01', 2, 6, 1);  -- Ativo
 
 
-- ---------------------------------------------------------------------
-- usuario (12 registros, todos os tipos de acesso)
-- ---------------------------------------------------------------------
INSERT INTO usuario (id, nome, senha_hash, esta_ativo, email, cargo, tipo_acesso, fk_endereco_id, data_nascimento, primeiro_acesso) VALUES
-- Administradores (Admin@123)
(1,  'Roberto Almeida',   '6G94qKPK8LYNjnTllCqm2G3BUM08AzOK7yW30tfjrMc=', TRUE,  'roberto.almeida@colegiohorizonte.com.br', 'Diretor de TI',            1, 1, '1980-05-12', FALSE),
(2,  'Fernanda Costa',    '6G94qKPK8LYNjnTllCqm2G3BUM08AzOK7yW30tfjrMc=', TRUE,  'fernanda.costa@faculdadenovaera.edu.br',  'Coordenadora de Sistemas', 1, 3, '1985-09-23', FALSE),
(3,  'Marcos Pereira',    '6G94qKPK8LYNjnTllCqm2G3BUM08AzOK7yW30tfjrMc=', TRUE,  'marcos.pereira@techsul.com.br',          'Gerente de TI',            1, 4, '1978-11-02', FALSE),
-- Gestores (Gestor@123)
(4,  'Juliana Ribeiro',   'OdUOgiVwteFsm/3f3ZtH4o3Z/pZiSlWkQ4nyRd7ccq0=', TRUE,  'juliana.ribeiro@colegiohorizonte.com.br', 'Gestora Administrativa',   2, 2, '1988-03-17', FALSE),
(5,  'Paulo Henrique',    'OdUOgiVwteFsm/3f3ZtH4o3Z/pZiSlWkQ4nyRd7ccq0=', TRUE,  'paulo.henrique@techsul.com.br',           'Gestor de Operações',      2, 5, '1983-07-30', TRUE),
(6,  'Patrícia Gomes',    'OdUOgiVwteFsm/3f3ZtH4o3Z/pZiSlWkQ4nyRd7ccq0=', FALSE, 'patricia.gomes@vilaverde.sp.gov.br',      'Secretária de Gestão',     2, 6, '1975-12-08', TRUE),
-- Técnicos (Tecnico@123)
(7,  'Lucas Martins',     'hY/f267x+9cK7euX95T0TOj1LDyz92FiQ8iN4RrU6kA=', TRUE,  'lucas.martins@colegiohorizonte.com.br',   'Técnico de Suporte',       3, 1, '1992-01-25', FALSE),
(8,  'Camila Rocha',      'hY/f267x+9cK7euX95T0TOj1LDyz92FiQ8iN4RrU6kA=', TRUE,  'camila.rocha@faculdadenovaera.edu.br',    'Analista de Infraestrutura', 3, 3, '1994-06-14', FALSE),
(9,  'Diego Fernandes',   'hY/f267x+9cK7euX95T0TOj1LDyz92FiQ8iN4RrU6kA=', FALSE, 'diego.fernandes@techsul.com.br',          'Técnico de Redes',         3, 4, '1990-10-09', TRUE),
-- Solicitantes (Solicitante@123)
(10, 'Beatriz Nunes',     'hgLYX7m7cL9CT4fAcq41OvkXspdSHTZ5AZT2+SOXNZo=', TRUE,  'beatriz.nunes@colegiohorizonte.com.br',    'Professora',               4, 2, '1991-04-04', FALSE),
(11, 'Rafael Teixeira',   'hgLYX7m7cL9CT4fAcq41OvkXspdSHTZ5AZT2+SOXNZo=', TRUE,  'rafael.teixeira@faculdadenovaera.edu.br',  'Professor',                4, 3, '1987-08-19', TRUE),
(12, 'Larissa Moura',     'hgLYX7m7cL9CT4fAcq41OvkXspdSHTZ5AZT2+SOXNZo=', FALSE, 'larissa.moura@vilaverde.sp.gov.br',        'Assistente Administrativo',4, 6, '1996-02-28', TRUE);
 
 
-- ---------------------------------------------------------------------
-- pagamento (10 registros; métodos e situações variadas)
-- ---------------------------------------------------------------------
INSERT INTO pagamento (id, valor, data_pagamento, foi_realizado, fk_contrato_id, metodo_pagamento) VALUES
(1,  199.90, '2026-01-15 10:30:00', TRUE,  1, 1),
(2,  199.90, '2026-02-14 09:15:00', TRUE,  1, 3),
(3,  399.90, '2026-03-01 14:00:00', TRUE,  2, 3),
(4,  399.90, '2026-04-02 11:45:00', TRUE,  2, 2),
(5,  799.90, '2026-02-20 16:20:00', TRUE,  3, 1),
(6,  799.90, '2026-03-22 08:50:00', TRUE,  3, 3),
(7, 1499.90, '2026-04-10 13:10:00', TRUE,  4, 1),
(8, 1499.90, '2026-05-12 10:05:00', FALSE, 4, 2),
(9,  199.90, '2026-05-05 15:30:00', FALSE, 5, 3),
(10, 399.90, '2026-06-01 09:00:00', TRUE,  6, 3);
 
 
-- ---------------------------------------------------------------------
-- foto_usuario (6 registros)
-- ---------------------------------------------------------------------
INSERT INTO foto_usuario (id, data_registro, url, fk_usuario_id) VALUES
-- Fotos de retrato do Pexels (https://www.pexels.com), conforme o gênero do usuário
(1, '2026-01-20 10:00:00', 'https://images.pexels.com/photos/15946547/pexels-photo-15946547.jpeg?auto=compress&cs=tinysrgb&w=400', 1),   -- Roberto
(2, '2026-02-25 11:30:00', 'https://images.pexels.com/photos/3484670/pexels-photo-3484670.jpeg?auto=compress&cs=tinysrgb&w=400',   2),   -- Fernanda
(3, '2026-03-25 09:45:00', 'https://images.pexels.com/photos/6273841/pexels-photo-6273841.jpeg?auto=compress&cs=tinysrgb&w=400',   3),   -- Marcos
(4, '2026-04-12 14:20:00', 'https://images.pexels.com/photos/1029572/pexels-photo-1029572.jpeg?auto=compress&cs=tinysrgb&w=400',   4),   -- Juliana
(5, '2026-05-18 16:10:00', 'https://images.pexels.com/photos/356147/pexels-photo-356147.jpeg?auto=compress&cs=tinysrgb&w=400',     7),   -- Lucas
(6, '2026-06-10 08:35:00', 'https://images.pexels.com/photos/2739792/pexels-photo-2739792.jpeg?auto=compress&cs=tinysrgb&w=400',   10);  -- Beatriz
 
 
-- ---------------------------------------------------------------------
-- verificacao_cadastro (4 registros; válidos, usados e expirados)
-- ---------------------------------------------------------------------
INSERT INTO verificacao_cadastro (id, codigo_verificacao, data_expiracao, email, esta_valido) VALUES
(1, '482913', NOW() + INTERVAL '5 minutes',  'novo.usuario1@colegiohorizonte.com.br', TRUE),
(2, '705628', NOW() + INTERVAL '3 minutes',  'novo.usuario2@techsul.com.br',          TRUE),
(3, '391847', NOW() - INTERVAL '1 hour',     'antigo.usuario@faculdadenovaera.edu.br', FALSE),
(4, '260154', NOW() - INTERVAL '2 days',     'expirado@vilaverde.sp.gov.br',          FALSE);
 
 
-- ---------------------------------------------------------------------
-- Ajusta as sequências (SERIAL) após inserts com ID explícito
-- ---------------------------------------------------------------------
SELECT setval(pg_get_serial_sequence('instituicao',          'id'), (SELECT MAX(id) FROM instituicao));
SELECT setval(pg_get_serial_sequence('plano',                'id'), (SELECT MAX(id) FROM plano));
SELECT setval(pg_get_serial_sequence('super_administrador',  'id'), (SELECT MAX(id) FROM super_administrador));
SELECT setval(pg_get_serial_sequence('endereco',             'id'), (SELECT MAX(id) FROM endereco));
SELECT setval(pg_get_serial_sequence('contrato',             'id'), (SELECT MAX(id) FROM contrato));
SELECT setval(pg_get_serial_sequence('usuario',              'id'), (SELECT MAX(id) FROM usuario));
SELECT setval(pg_get_serial_sequence('pagamento',            'id'), (SELECT MAX(id) FROM pagamento));
SELECT setval(pg_get_serial_sequence('foto_usuario',         'id'), (SELECT MAX(id) FROM foto_usuario));
SELECT setval(pg_get_serial_sequence('verificacao_cadastro', 'id'), (SELECT MAX(id) FROM verificacao_cadastro));