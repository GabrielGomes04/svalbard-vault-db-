-- Relatorio 1 - Inventario Geral de Lotes por Instituicao e Localizacao
EXPLAIN ANALYZE
SELECT 
    i.Nome_Instituicao AS instituicao,
    i.Pais_Origem AS pais,
    ct.Nome_Cientifico AS especie,
    ct.Nome_Comum AS nome_popular,
    ls.Status AS status_lote,
    ls.Data_Recebimento,
    c.Codigo_Rastreio_Caixa AS caixa,
    loc.Sala_Camara, loc.Corredor, loc.Estante, loc.Prateleira
FROM LOTE_SEMENTES ls
JOIN INSTITUICAO i ON ls.ID_Depositante = i.ID_Depositante
LEFT JOIN CATEGORIA_TAXONOMICA ct ON ls.ID_Taxon = ct.ID_Taxon
LEFT JOIN CAIXA c ON ls.ID_Caixa = c.ID_Caixa
LEFT JOIN HISTORICO_ALOCACAO_CAIXA hac ON c.ID_Caixa = hac.ID_Caixa AND hac.Data_Saida IS NULL
LEFT JOIN LOCALIZACAO loc ON hac.ID_Localizacao = loc.ID_Localizacao
ORDER BY i.Pais_Origem, i.Nome_Instituicao, ct.Nome_Cientifico;

-- Relatorio 2 - Historico Completo de Movimentacoes de Auditoria
EXPLAIN ANALYZE
SELECT 
    ma.ID_Movimentacao,
    ma.Tipo_Movimentacao,
    ma.Data_Hora,
    u.Nome AS responsavel,
    u.Tipo_Usuario,
    ls.ID_Lote,
    i.Nome_Instituicao,
    i.Pais_Origem,
    ct.Nome_Cientifico AS especie,
    ls.Status AS status_atual,
    ma.Assinatura_Digital_Hash
FROM MOVIMENTACAO_AUDITORIA ma
JOIN USUARIO u ON ma.ID_Usuario = u.ID_Usuario
JOIN LOTE_SEMENTES ls ON ma.ID_Lote = ls.ID_Lote
JOIN INSTITUICAO i ON ls.ID_Depositante = i.ID_Depositante
LEFT JOIN CATEGORIA_TAXONOMICA ct ON ls.ID_Taxon = ct.ID_Taxon
ORDER BY ma.Data_Hora DESC;

-- Relatorio 3 - Taxa de Ocupacao das Caixas por Camara
EXPLAIN ANALYZE
SELECT 
    loc.Sala_Camara, loc.Corredor, loc.Estante, loc.Prateleira,
    c.Codigo_Rastreio_Caixa, c.Capacidade_Maxima,
    COUNT(ls.ID_Lote) AS lotes_armazenados,
    c.Capacidade_Maxima - COUNT(ls.ID_Lote) AS espacos_disponiveis,
    ROUND((COUNT(ls.ID_Lote)::NUMERIC / c.Capacidade_Maxima) * 100, 2) AS percentual_ocupacao
FROM CAIXA c
JOIN HISTORICO_ALOCACAO_CAIXA hac ON c.ID_Caixa = hac.ID_Caixa AND hac.Data_Saida IS NULL
JOIN LOCALIZACAO loc ON hac.ID_Localizacao = loc.ID_Localizacao
LEFT JOIN LOTE_SEMENTES ls ON c.ID_Caixa = ls.ID_Caixa AND ls.Status = 'Armazenado'
GROUP BY loc.Sala_Camara, loc.Corredor, loc.Estante, loc.Prateleira, c.ID_Caixa, c.Codigo_Rastreio_Caixa, c.Capacidade_Maxima
ORDER BY loc.Sala_Camara, percentual_ocupacao DESC;
