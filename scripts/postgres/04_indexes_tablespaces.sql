-- Indices em chaves estrangeiras
CREATE INDEX idx_lote_depositante ON LOTE_SEMENTES (ID_Depositante);
CREATE INDEX idx_lote_taxon ON LOTE_SEMENTES (ID_Taxon);
CREATE INDEX idx_lote_caixa ON LOTE_SEMENTES (ID_Caixa);
CREATE INDEX idx_repr_depositante ON REPRESENTANTE (ID_Depositante);
CREATE INDEX idx_historico_caixa ON HISTORICO_ALOCACAO_CAIXA (ID_Caixa);
CREATE INDEX idx_historico_localizacao ON HISTORICO_ALOCACAO_CAIXA (ID_Localizacao);
CREATE INDEX idx_auditoria_lote ON MOVIMENTACAO_AUDITORIA (ID_Lote);
CREATE INDEX idx_auditoria_usuario ON MOVIMENTACAO_AUDITORIA (ID_Usuario);
CREATE INDEX idx_taxon_pai ON CATEGORIA_TAXONOMICA (ID_Pai_Taxon);

-- Indices em colunas de filtro frequente
CREATE INDEX idx_lote_status ON LOTE_SEMENTES (Status);
CREATE INDEX idx_historico_saida ON HISTORICO_ALOCACAO_CAIXA (Data_Saida) WHERE Data_Saida IS NULL;
CREATE INDEX idx_auditoria_data ON MOVIMENTACAO_AUDITORIA (Data_Hora DESC);
CREATE INDEX idx_taxon_rank ON CATEGORIA_TAXONOMICA (Rank_Taxonomico);

-- Indice composto para a politica RLS (Caixa Preta)
CREATE INDEX idx_lote_depositante_status ON LOTE_SEMENTES (ID_Depositante, Status);

-- Estrutura de Tablespaces (Exemplo de organizacao fisica)
/*
CREATE TABLESPACE ts_dados_principais LOCATION '/mnt/nvme/tablespaces/dados';
CREATE TABLESPACE ts_indices LOCATION '/mnt/nvme/tablespaces/indices';
CREATE TABLESPACE ts_historico LOCATION '/mnt/hdd/tablespaces/historico';

ALTER TABLE LOTE_SEMENTES SET TABLESPACE ts_dados_principais;
ALTER TABLE CATEGORIA_TAXONOMICA SET TABLESPACE ts_dados_principais;
ALTER TABLE INSTITUICAO SET TABLESPACE ts_dados_principais;

ALTER TABLE MOVIMENTACAO_AUDITORIA SET TABLESPACE ts_historico;
ALTER TABLE HISTORICO_ALOCACAO_CAIXA SET TABLESPACE ts_historico;

ALTER INDEX idx_lote_depositante_status SET TABLESPACE ts_indices;
ALTER INDEX idx_lote_status SET TABLESPACE ts_indices;
ALTER INDEX idx_historico_saida SET TABLESPACE ts_indices;
ALTER INDEX idx_auditoria_data SET TABLESPACE ts_indices;
*/
