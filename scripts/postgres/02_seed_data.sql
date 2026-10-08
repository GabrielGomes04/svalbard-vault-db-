-- Instituicoes depositantes
INSERT INTO INSTITUICAO (Nome_Instituicao, Pais_Origem) VALUES
('EMBRAPA - Empresa Brasileira de Pesquisa Agropecuária', 'Brasil'),
('ICARDA - International Center for Agricultural Research', 'Líbano'),
('Nordic Genetic Resource Center (NordGen)', 'Noruega'),
('National Bureau of Plant Genetic Resources (NBPGR)', 'Índia'),
('USDA Agricultural Research Service', 'Estados Unidos');

-- Usuarios (Administradores e Representantes)
INSERT INTO USUARIO (Nome, Login, Senha, Tipo_Usuario) VALUES
('Erik Solberg', 'erik.solberg', '$2b$12$Kg8aHfXzUuql', 'ADMINISTRADOR'),
('Anika Thorvaldsen', 'anika.thor', '$2b$12$Pq7dGhYrVVm2', 'ADMINISTRADOR'),
('Dr. Carlos Nunes', 'carlos.nunes', '$2b$12$Lr9eKiZsWWn3', 'REPRESENTANTE'),
('Dra. Priya Menon', 'priya.menon', '$2b$12$Ms0fLjAtXX04', 'REPRESENTANTE'),
('Dr. James Carter', 'james.carter', '$2b$12$Nt1gMkBuYYp5', 'REPRESENTANTE');

INSERT INTO ADMINISTRADOR (ID_Usuario, Nivel_Permissao, Turno_Trabalho) VALUES
(1, 'Master', 'Diurno'),
(2, 'Auditor', 'Noturno');

INSERT INTO REPRESENTANTE (ID_Usuario, ID_Depositante, Cargo_Oficial) VALUES
(3, 1, 'Pesquisador Sênior em Recursos Genéticos'),
(4, 4, 'Curadora de Germoplasma'),
(5, 5, 'Diretor de Conservação Ex Situ');

-- Localizacoes nas camaras
INSERT INTO LOCALIZACAO (Sala_Camara, Corredor, Estante, Prateleira) VALUES
('Câmara 1', 'A', 'E01', 'P1'),
('Câmara 1', 'A', 'E01', 'P2'),
('Câmara 1', 'B', 'E03', 'P1'),
('Câmara 2', 'A', 'E01', 'P1'),
('Câmara 2', 'B', 'E02', 'P3');

-- Caixas hermeticas
INSERT INTO CAIXA (Codigo_Rastreio_Caixa, Capacidade_Maxima) VALUES
('SVL-BOX-2024-001', 400),
('SVL-BOX-2024-002', 400),
('SVL-BOX-2024-003', 400),
('SVL-BOX-2024-004', 400);

-- Historico de alocacao das caixas
INSERT INTO HISTORICO_ALOCACAO_CAIXA (ID_Caixa, ID_Localizacao, Data_Entrada, Data_Saida) VALUES
(1, 1, '2024-01-10 08:00:00', NULL),
(2, 2, '2024-01-10 08:00:00', NULL),
(3, 4, '2024-02-15 09:30:00', NULL),
(4, 5, '2024-03-20 10:00:00', NULL);

-- Taxonomia (Familia -> Genero -> Especie)
INSERT INTO CATEGORIA_TAXONOMICA (Nome_Cientifico, Nome_Comum, Rank_Taxonomico, ID_Pai_Taxon) VALUES
('Poaceae', 'Gramíneas', 'FAMILIA', NULL),
('Triticum', 'Trigo', 'GENERO', 1),
('Oryza', 'Arroz', 'GENERO', 1),
('Zea', 'Milho', 'GENERO', 1),
('Triticum aestivum', 'Trigo Comum', 'ESPECIE', 2),
('Triticum durum', 'Trigo Durum', 'ESPECIE', 2),
('Oryza sativa', 'Arroz Asiático', 'ESPECIE', 3),
('Zea mays', 'Milho', 'ESPECIE', 4),
('Fabaceae', 'Leguminosas', 'FAMILIA', NULL),
('Phaseolus', 'Feijão', 'GENERO', 9),
('Phaseolus vulgaris', 'Feijão Comum', 'ESPECIE', 10);

-- Lotes de sementes
INSERT INTO LOTE_SEMENTES (ID_Depositante, ID_Taxon, ID_Caixa, Data_Recebimento, Status) VALUES
(1, 5, 1, '2024-01-15', 'Armazenado'),
(1, 8, 1, '2024-01-15', 'Armazenado'),
(1, 11, 2, '2024-02-10', 'Armazenado'),
(2, 6, 3, '2024-02-20', 'Armazenado'),
(2, 7, 4, '2024-03-05', 'Armazenado'),
(4, 5, 4, '2024-03-10', 'Armazenado'),
(5, NULL, NULL, '2024-03-01', 'Em Quarentena'),
(3, NULL, NULL, '2024-03-15', 'Pendente');

-- Registros de auditoria
INSERT INTO MOVIMENTACAO_AUDITORIA (ID_Lote, ID_Usuario, Tipo_Movimentacao, Data_Hora, Assinatura_Digital_Hash) VALUES
(1, 1, 'Rececao', '2024-01-15 10:00:00', encode(sha256('1Rececao2024-01-15 10:00:00'), 'hex')),
(1, 1, 'Armazenamento Final', '2024-01-16 14:00:00', encode(sha256('1Armazenamento Final2024-01-16 14:00:00'), 'hex')),
(2, 1, 'Rececao', '2024-01-15 10:05:00', encode(sha256('2Rececao2024-01-15 10:05:00'), 'hex')),
(5, 2, 'Rececao', '2024-03-01 09:00:00', encode(sha256('5Rececao2024-03-01 09:00:00'), 'hex'));
