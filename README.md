# svalbard-vault-db-
Recentemente projetei o Svalbard VaultDB, um sistema multimodelo para o Banco Mundial de Sementes. Implementei isolamento de dados com Row-Level Security (RLS) nativo do PostgreSQL, triggers PL/pgSQL para auditoria imutável via hash SHA-256, otimização física com Tablespaces em SSD/HDD e modelagem em grafos no Neo4j para navegação filogenética.
