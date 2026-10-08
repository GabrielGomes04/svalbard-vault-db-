// Consulta 1: Arvore Filogenetica Navegavel (grau de parentesco ate 3 niveis)
MATCH (esp:Especie {nome: 'Triticum aestivum'})-[:CRUZA_COM*1..3]-(parente)
RETURN parente.nome, parente.rank, length(path) AS grau_parentesco
ORDER BY grau_parentesco;

// Consulta 2: Analise de Diversidade Genética por Pais
MATCH (p:Pais)<-[:ORIGINADO_DE]-(i:Instituicao)-[:DEPOSITOU]->(l:Lote)-[:CLASSIFICADO_COMO]->(e:Especie)-[:PERTENCE_A*]->(f:Familia)
RETURN p.nome AS pais,
       COUNT(DISTINCT e) AS especies_unicas,
       COUNT(DISTINCT f) AS familias_distintas,
       COUNT(l) AS total_lotes
ORDER BY especies_unicas DESC;
