-- Tabela: INSTITUICAO
CREATE TABLE INSTITUICAO (
    ID_Depositante SERIAL PRIMARY KEY,
    Nome_Instituicao VARCHAR(200) NOT NULL,
    Pais_Origem VARCHAR(100) NOT NULL
);

-- Tabela: USUARIO (supertipo)
CREATE TABLE USUARIO (
    ID_Usuario SERIAL PRIMARY KEY,
    Nome VARCHAR(150) NOT NULL,
    Login VARCHAR(100) NOT NULL UNIQUE,
    Senha VARCHAR(255) NOT NULL,
    Tipo_Usuario VARCHAR(20) NOT NULL,
    CONSTRAINT chk_tipo_usuario CHECK (Tipo_Usuario IN ('ADMINISTRADOR', 'REPRESENTANTE'))
);

-- Tabela: CAIXA
CREATE TABLE CAIXA (
    ID_Caixa SERIAL PRIMARY KEY,
    Codigo_Rastreio_Caixa VARCHAR(100) NOT NULL UNIQUE,
    Capacidade_Maxima INT NOT NULL DEFAULT 400
);

-- Tabela: LOCALIZACAO
CREATE TABLE LOCALIZACAO (
    ID_Localizacao SERIAL PRIMARY KEY,
    Sala_Camara VARCHAR(50) NOT NULL,
    Corredor VARCHAR(50) NOT NULL,
    Estante VARCHAR(50) NOT NULL,
    Prateleira VARCHAR(50) NOT NULL
);

-- Tabela: CATEGORIA_TAXONOMICA (autorrelacionamento recursivo)
CREATE TABLE CATEGORIA_TAXONOMICA (
    ID_Taxon SERIAL PRIMARY KEY,
    Nome_Cientifico VARCHAR(200) NOT NULL UNIQUE,
    Nome_Comum VARCHAR(200),
    Rank_Taxonomico VARCHAR(10) NOT NULL,
    ID_Pai_Taxon INT,
    CONSTRAINT chk_rank CHECK (Rank_Taxonomico IN ('FAMILIA', 'GENERO', 'ESPECIE')),
    CONSTRAINT fk_pai_taxon FOREIGN KEY (ID_Pai_Taxon) REFERENCES CATEGORIA_TAXONOMICA (ID_Taxon)
);

-- Tabela: ADMINISTRADOR (subtipo de USUARIO)
CREATE TABLE ADMINISTRADOR (
    ID_Usuario INT PRIMARY KEY,
    Nivel_Permissao VARCHAR(50) NOT NULL,
    Turno_Trabalho VARCHAR(30) NOT NULL,
    CONSTRAINT fk_admin_usuario FOREIGN KEY (ID_Usuario) REFERENCES USUARIO (ID_Usuario)
);

-- Tabela: REPRESENTANTE (subtipo de USUARIO)
CREATE TABLE REPRESENTANTE (
    ID_Usuario INT PRIMARY KEY,
    ID_Depositante INT NOT NULL,
    Cargo_Oficial VARCHAR(100) NOT NULL,
    CONSTRAINT fk_repr_usuario FOREIGN KEY (ID_Usuario) REFERENCES USUARIO (ID_Usuario),
    CONSTRAINT fk_repr_instituicao FOREIGN KEY (ID_Depositante) REFERENCES INSTITUICAO (ID_Depositante)
);

-- Tabela: LOTE_SEMENTES (entidade central)
CREATE TABLE LOTE_SEMENTES (
    ID_Lote SERIAL PRIMARY KEY,
    ID_Depositante INT NOT NULL,
    ID_Taxon INT,
    ID_Caixa INT,
    Data_Recebimento DATE NOT NULL,
    Status VARCHAR(30) NOT NULL,
    CONSTRAINT chk_status CHECK (Status IN (
        'Pendente', 'Aguardando Homologacao', 'Em Quarentena',
        'Pronto para Alocacao', 'Armazenado', 'Inviavel', 'Retirado'
    )),
    CONSTRAINT fk_lote_depositante FOREIGN KEY (ID_Depositante) REFERENCES INSTITUICAO (ID_Depositante),
    CONSTRAINT fk_lote_taxon FOREIGN KEY (ID_Taxon) REFERENCES CATEGORIA_TAXONOMICA (ID_Taxon),
    CONSTRAINT fk_lote_caixa FOREIGN KEY (ID_Caixa) REFERENCES CAIXA (ID_Caixa)
);

-- Tabela: HISTORICO_ALOCACAO_CAIXA (N:M entre CAIXA e LOCALIZACAO)
CREATE TABLE HISTORICO_ALOCACAO_CAIXA (
    ID_Historico SERIAL PRIMARY KEY,
    ID_Caixa INT NOT NULL,
    ID_Localizacao INT NOT NULL,
    Data_Entrada TIMESTAMP NOT NULL,
    Data_Saida TIMESTAMP,
    CONSTRAINT fk_hist_caixa FOREIGN KEY (ID_Caixa) REFERENCES CAIXA (ID_Caixa),
    CONSTRAINT fk_hist_localizacao FOREIGN KEY (ID_Localizacao) REFERENCES LOCALIZACAO (ID_Localizacao)
);

-- Tabela: MOVIMENTACAO_AUDITORIA (log imutavel)
CREATE TABLE MOVIMENTACAO_AUDITORIA (
    ID_Movimentacao SERIAL PRIMARY KEY,
    ID_Lote INT NOT NULL,
    ID_Usuario INT NOT NULL,
    Tipo_Movimentacao VARCHAR(30) NOT NULL,
    Data_Hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Assinatura_Digital_Hash VARCHAR(255) NOT NULL,
    CONSTRAINT chk_tipo_mov CHECK (Tipo_Movimentacao IN (
        'Rececao', 'Homologacao Taxonomica', 'Descarte Sanitario',
        'Armazenamento Final', 'Mudanca de Caixa', 'Retirada'
    )),
    CONSTRAINT fk_mov_lote FOREIGN KEY (ID_Lote) REFERENCES LOTE_SEMENTES (ID_Lote),
    CONSTRAINT fk_mov_usuario FOREIGN KEY (ID_Usuario) REFERENCES USUARIO (ID_Usuario)
);
