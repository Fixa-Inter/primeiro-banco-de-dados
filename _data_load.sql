-- =====================================================================
-- DATALOAD
-- Execute DEPOIS do script de criação das tabelas/views.
-- Os dados de teste respeitam todas as constraints e regras de negócio:
--
--   instituicao.tipo_instituicao : 1=Escola | 2=Faculdade | 3=Empresa | 4=Órgão Público
--   pagamento.metodo_pagamento   : 1=Crédito | 2=Débito | 3=Pix
--   usuario.tipo_acesso          : 1=Administrador | 2=Gestor | 3=Técnico | 4=Solicitante
--   contrato.status_contrato     : 1=Ativo | 2=Inativo | 3=Cancelado
--
-- As chaves estrangeiras são resolvidas por chaves naturais (cnpj, email,
-- nome), então o script não depende dos valores gerados pelo SERIAL.
-- ATENÇÃO: os hashes de senha abaixo são FICTÍCIOS (apenas no formato
-- bcrypt). Substitua por hashes gerados pela sua aplicação para poder
-- fazer login.
-- =====================================================================

-- Limpa os dados existentes (idempotente) e reinicia os IDs
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
-- 1) INSTITUIÇÕES
-- ---------------------------------------------------------------------
INSERT INTO instituicao (nome, email_corporativo, data_cadastro, dominio_email, tipo_instituicao, senha_hash) VALUES
('Escola Monteiro Lobato',          'contato@monteirolobato.edu.br',  '2025-01-10', 'monteirolobato.edu.br',  1, '$2b$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ012345'),
('Faculdade Horizonte',             'contato@fachorizonte.edu.br',    '2025-02-20', 'fachorizonte.edu.br',    2, '$2b$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ012345'),
('TechNova Soluções',               'contato@technova.com.br',        '2025-03-05', 'technova.com.br',        3, '$2b$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ012345'),
('Prefeitura Municipal de Campinas','contato@campinas.sp.gov.br',     '2025-05-15', 'campinas.sp.gov.br',     4, '$2b$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ012345'),
('Colégio Aurora',                  'contato@colegioaurora.com.br',   '2026-01-08', 'colegioaurora.com.br',   1, '$2b$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ012345'),
('Universidade Vale Verde',         'contato@valeverde.edu.br',       '2026-05-20', 'valeverde.edu.br',       2, '$2b$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ012345');


-- ---------------------------------------------------------------------
-- 2) PLANOS
-- ---------------------------------------------------------------------
INSERT INTO plano (nome, valor_mensal, duracao_meses, descricao) VALUES
('Gratuito',     0.00,   3,  'Período de teste com recursos limitados'),
('Básico',       199.90, 12, 'Até 50 usuários e suporte por e-mail'),
('Profissional', 399.90, 12, 'Até 200 usuários, relatórios e suporte prioritário'),
('Enterprise',   899.90, 24, 'Usuários ilimitados, SLA dedicado e integrações');


-- ---------------------------------------------------------------------
-- 3) SUPER ADMINISTRADORES
-- ---------------------------------------------------------------------
INSERT INTO super_administrador (nome, senha_hash, email) VALUES
('Administrador Geral', '$2b$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ012345', 'admin@plataforma.com.br'),
('Suporte Plataforma',  '$2b$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ012345', 'suporte@plataforma.com.br');


-- ---------------------------------------------------------------------
-- 4) ENDEREÇOS (unidades das instituições)
-- ---------------------------------------------------------------------
INSERT INTO endereco (nome, rua, bairro, complemento, cidade, estado, numero, cep, fk_instituicao_id, cnpj)
SELECT v.nome, v.rua, v.bairro, v.complemento, v.cidade, v.estado, v.numero, v.cep, i.id, v.cnpj
FROM (VALUES
    ('Sede Monteiro Lobato',     'Rua das Acácias',          'Vila Mariana',  'Bloco A',        'São Paulo',      'SP', '120',  '04101000', 'contato@monteirolobato.edu.br', '11111111000101'),
    ('Unidade Zona Leste',       'Avenida Radial Leste',     'Tatuapé',       NULL,             'São Paulo',      'SP', '3450', '03071000', 'contato@monteirolobato.edu.br', '11111111000202'),
    ('Campus Central',           'Avenida Rio Branco',       'Centro',        'Prédio Central', 'Rio de Janeiro', 'RJ', '85',   '20040009', 'contato@fachorizonte.edu.br',   '22222222000103'),
    ('Campus Barra',             'Avenida das Américas',     'Barra da Tijuca', NULL,           'Rio de Janeiro', 'RJ', '5000', '22640102', 'contato@fachorizonte.edu.br',   '22222222000204'),
    ('Matriz',                   'Avenida Afonso Pena',      'Funcionários',  '10º andar',      'Belo Horizonte', 'MG', '1500', '30130003', 'contato@technova.com.br',       '33333333000105'),
    ('Filial Curitiba',          'Rua XV de Novembro',       'Centro',        'Sala 402',       'Curitiba',       'PR', '700',  '80020310', 'contato@technova.com.br',       '33333333000206'),
    ('Secretaria de Educação',   'Avenida Anchieta',         'Centro',        NULL,             'Campinas',       'SP', '200',  '13015904', 'contato@campinas.sp.gov.br',    '44444444000107'),
    ('Unidade Única',            'Rua Padre Chagas',         'Moinhos de Vento', NULL,          'Porto Alegre',   'RS', '45',   '90570080', 'contato@colegioaurora.com.br',  '55555555000108'),
    ('Campus Vale',              'Rodovia SC-401',           'Saco Grande',   'Km 5',           'Florianópolis',  'SC', '1000', '88032005', 'contato@valeverde.edu.br',      '66666666000109')
) AS v(nome, rua, bairro, complemento, cidade, estado, numero, cep, email_inst, cnpj)
JOIN instituicao i ON i.email_corporativo = v.email_inst;


-- ---------------------------------------------------------------------
-- 5) CONTRATOS  (status: 1=Ativo | 2=Inativo | 3=Cancelado)
-- ---------------------------------------------------------------------
INSERT INTO contrato (data_inicio, data_vencimento, fk_plano_id, fk_endereco_id, status_contrato)
SELECT v.inicio::date, v.vencimento::date, p.id, e.id, v.status
FROM (VALUES
    ('11111111000101', 'Profissional', '2026-01-10', '2027-01-10', 1),
    ('11111111000202', 'Básico',       '2026-02-15', '2027-02-15', 1),
    ('22222222000103', 'Enterprise',   '2025-03-01', '2027-03-01', 1),
    ('22222222000204', 'Profissional', '2025-01-05', '2026-01-05', 2),  -- expirado
    ('33333333000105', 'Enterprise',   '2026-01-20', '2028-01-20', 1),
    ('33333333000206', 'Básico',       '2026-03-01', '2027-03-01', 3),  -- cancelado
    ('44444444000107', 'Profissional', '2026-05-10', '2027-05-10', 1),
    ('55555555000108', 'Gratuito',     '2026-09-01', '2026-12-01', 1),
    ('66666666000109', 'Básico',       '2026-06-01', '2027-06-01', 1)
) AS v(cnpj, plano, inicio, vencimento, status)
JOIN endereco e ON e.cnpj = v.cnpj
JOIN plano p    ON p.nome = v.plano;


-- ---------------------------------------------------------------------
-- 6) USUÁRIOS  (tipo_acesso: 1=Admin | 2=Gestor | 3=Técnico | 4=Solicitante)
-- ---------------------------------------------------------------------
INSERT INTO usuario (nome, senha_hash, esta_ativo, email, cargo, tipo_acesso, fk_endereco_id, data_nascimento, primeiro_acesso)
SELECT v.nome, '$2b$10$abcdefghijklmnopqrstuuABCDEFGHIJKLMNOPQRSTUVWXYZ012345',
       v.ativo, v.email, v.cargo, v.tipo, e.id, v.nascimento::date, v.primeiro_acesso
FROM (VALUES
    -- Escola Monteiro Lobato - Sede
    ('11111111000101', 'Carla Mendes',        'carla.mendes@monteirolobato.edu.br',     'Diretora',                1, '1980-04-12', true,  false),
    ('11111111000101', 'Roberto Alves',       'roberto.alves@monteirolobato.edu.br',    'Coordenador',             2, '1985-09-30', true,  false),
    ('11111111000101', 'Felipe Souza',        'felipe.souza@monteirolobato.edu.br',     'Técnico de TI',           3, '1992-01-25', true,  false),
    ('11111111000101', 'Juliana Costa',       'juliana.costa@monteirolobato.edu.br',    'Professora',              4, '1990-07-08', true,  true),
    -- Escola Monteiro Lobato - Zona Leste
    ('11111111000202', 'Marcos Pereira',      'marcos.pereira@monteirolobato.edu.br',   'Coordenador',             2, '1983-11-02', true,  false),
    ('11111111000202', 'Patrícia Lima',       'patricia.lima@monteirolobato.edu.br',    'Professora',              4, '1994-03-18', false, true),
    -- Faculdade Horizonte - Campus Central
    ('22222222000103', 'Henrique Barbosa',    'henrique.barbosa@fachorizonte.edu.br',   'Diretor Acadêmico',       1, '1975-06-21', true,  false),
    ('22222222000103', 'Aline Ferreira',      'aline.ferreira@fachorizonte.edu.br',     'Gestora de Laboratórios', 2, '1988-12-05', true,  false),
    ('22222222000103', 'Thiago Ramos',        'thiago.ramos@fachorizonte.edu.br',       'Técnico de Laboratório',  3, '1995-02-14', true,  false),
    ('22222222000103', 'Beatriz Nogueira',    'beatriz.nogueira@fachorizonte.edu.br',   'Professora',              4, '1987-08-29', true,  true),
    -- Faculdade Horizonte - Campus Barra
    ('22222222000204', 'Rafael Duarte',       'rafael.duarte@fachorizonte.edu.br',      'Gestor de Campus',        2, '1982-05-17', false, false),
    ('22222222000204', 'Camila Teixeira',     'camila.teixeira@fachorizonte.edu.br',    'Professora',              4, '1991-10-03', false, true),
    -- TechNova - Matriz
    ('33333333000105', 'Eduardo Martins',     'eduardo.martins@technova.com.br',        'CTO',                     1, '1978-02-27', true,  false),
    ('33333333000105', 'Fernanda Rocha',      'fernanda.rocha@technova.com.br',         'Gerente de Operações',    2, '1986-07-19', true,  false),
    ('33333333000105', 'Lucas Andrade',       'lucas.andrade@technova.com.br',          'Analista de Suporte',     3, '1996-09-09', true,  false),
    ('33333333000105', 'Mariana Cardoso',     'mariana.cardoso@technova.com.br',        'Analista de RH',          4, '1993-04-01', true,  true),
    -- TechNova - Filial Curitiba
    ('33333333000206', 'Gustavo Pinto',       'gustavo.pinto@technova.com.br',          'Gerente de Filial',       2, '1984-01-11', false, false),
    ('33333333000206', 'Larissa Moura',       'larissa.moura@technova.com.br',          'Assistente Administrativo', 4, '1997-06-23', false, true),
    -- Prefeitura de Campinas
    ('44444444000107', 'Sérgio Vasconcelos',  'sergio.vasconcelos@campinas.sp.gov.br',  'Secretário de Educação',  1, '1972-03-15', true,  false),
    ('44444444000107', 'Débora Nascimento',   'debora.nascimento@campinas.sp.gov.br',   'Gestora de Projetos',     2, '1981-12-22', true,  false),
    ('44444444000107', 'Renato Figueiredo',   'renato.figueiredo@campinas.sp.gov.br',   'Técnico de Informática',  3, '1989-05-06', true,  false),
    ('44444444000107', 'Isabela Castro',      'isabela.castro@campinas.sp.gov.br',      'Servidora Pública',       4, '1992-11-30', true,  true),
    -- Colégio Aurora
    ('55555555000108', 'Vanessa Oliveira',    'vanessa.oliveira@colegioaurora.com.br',  'Diretora',                1, '1979-09-04', true,  false),
    ('55555555000108', 'André Siqueira',      'andre.siqueira@colegioaurora.com.br',    'Professor',               4, '1990-01-16', true,  true),
    -- Universidade Vale Verde
    ('66666666000109', 'Cláudia Brandão',     'claudia.brandao@valeverde.edu.br',       'Reitora',                 1, '1970-08-13', true,  false),
    ('66666666000109', 'Paulo Henrique Lopes','paulo.lopes@valeverde.edu.br',           'Gestor de TI',            2, '1983-02-09', true,  false),
    ('66666666000109', 'Natália Freitas',     'natalia.freitas@valeverde.edu.br',       'Técnica de Suporte',      3, '1998-12-28', true,  true),
    ('66666666000109', 'Diego Carvalho',      'diego.carvalho@valeverde.edu.br',        'Pesquisador',             4, '1994-07-31', false, true)
) AS v(cnpj, nome, email, cargo, tipo, nascimento, ativo, primeiro_acesso)
JOIN endereco e ON e.cnpj = v.cnpj;


-- ---------------------------------------------------------------------
-- 7) PAGAMENTOS
-- Uma parcela mensal por contrato, a partir da data de início, até hoje
-- (e antes do vencimento). Contratos Inativos/Cancelados têm no máximo
-- 3 parcelas. Método de pagamento alterna entre 1=Crédito, 2=Débito, 3=Pix.
-- Parcelas de meses anteriores ao atual são sempre pagas; no mês atual,
-- alguns contratos ficam com a parcela pendente (foi_realizado = false).
-- ---------------------------------------------------------------------
INSERT INTO pagamento (valor, data_pagamento, foi_realizado, fk_contrato_id, metodo_pagamento)
SELECT
    p.valor_mensal,
    (c.data_inicio + make_interval(months => n))::timestamp,
    (c.data_inicio + make_interval(months => n)) < date_trunc('month', current_date)
        OR c.id % 3 <> 0,
    c.id,
    ((c.id + n) % 3) + 1
FROM contrato c
JOIN plano p ON p.id = c.fk_plano_id
CROSS JOIN generate_series(0, 24) AS n
WHERE (c.data_inicio + make_interval(months => n)) <= current_date
  AND (c.data_inicio + make_interval(months => n)) <  c.data_vencimento
  AND (c.status_contrato = 1 OR n < 3);


-- ---------------------------------------------------------------------
-- 8) FOTOS DE USUÁRIO
-- ---------------------------------------------------------------------
INSERT INTO foto_usuario (data_registro, url, fk_usuario_id)
SELECT v.registro::timestamp, v.url, u.id
FROM (VALUES
    ('carla.mendes@monteirolobato.edu.br',   '2026-01-12 09:15:00', 'https://cdn.exemplo.com.br/fotos/carla-mendes.jpg'),
    ('roberto.alves@monteirolobato.edu.br',  '2026-01-12 10:02:00', 'https://cdn.exemplo.com.br/fotos/roberto-alves.jpg'),
    ('felipe.souza@monteirolobato.edu.br',   '2026-01-13 14:30:00', 'https://cdn.exemplo.com.br/fotos/felipe-souza.jpg'),
    ('henrique.barbosa@fachorizonte.edu.br', '2025-03-05 08:45:00', 'https://cdn.exemplo.com.br/fotos/henrique-barbosa.jpg'),
    ('aline.ferreira@fachorizonte.edu.br',   '2025-03-06 11:20:00', 'https://cdn.exemplo.com.br/fotos/aline-ferreira.jpg'),
    ('eduardo.martins@technova.com.br',      '2026-01-22 16:10:00', 'https://cdn.exemplo.com.br/fotos/eduardo-martins.jpg'),
    ('fernanda.rocha@technova.com.br',       '2026-01-22 16:45:00', 'https://cdn.exemplo.com.br/fotos/fernanda-rocha.jpg'),
    ('lucas.andrade@technova.com.br',        '2026-01-23 09:00:00', 'https://cdn.exemplo.com.br/fotos/lucas-andrade.jpg'),
    ('sergio.vasconcelos@campinas.sp.gov.br','2026-05-12 13:25:00', 'https://cdn.exemplo.com.br/fotos/sergio-vasconcelos.jpg'),
    ('vanessa.oliveira@colegioaurora.com.br','2026-09-02 10:40:00', 'https://cdn.exemplo.com.br/fotos/vanessa-oliveira.jpg'),
    ('claudia.brandao@valeverde.edu.br',     '2026-06-03 15:55:00', 'https://cdn.exemplo.com.br/fotos/claudia-brandao.jpg'),
    ('claudia.brandao@valeverde.edu.br',     '2026-09-15 08:20:00', 'https://cdn.exemplo.com.br/fotos/claudia-brandao-v2.jpg')
) AS v(email, registro, url)
JOIN usuario u ON u.email = v.email;


-- ---------------------------------------------------------------------
-- 9) VERIFICAÇÃO DE CADASTRO (códigos de 6 caracteres, validade 5 min)
-- ---------------------------------------------------------------------
INSERT INTO verificacao_cadastro (codigo_verificacao, data_expiracao, email, esta_valido) VALUES
('482913', NOW() + INTERVAL '5 minutes',  'novo.usuario@technova.com.br',       TRUE),   -- ainda válido
('105738', NOW() - INTERVAL '1 hour',     'ana.souza@colegioaurora.com.br',     FALSE),  -- expirado
('339620', NOW() - INTERVAL '1 day',    'teste@valeverde.edu.br',             FALSE),  -- expirado
('774201', NOW() + INTERVAL '3 minutes',  'joao.lima@campinas.sp.gov.br',       TRUE);   -- ainda válido