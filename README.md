# Svalbard VaultDB — System for Global Seed Vault Management

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue)
![Security](https://img.shields.io/badge/RLS-Enabled-green)
![Neo4j](https://img.shields.io/badge/Neo4j-Graph-orange)
![Docker](https://img.shields.io/badge/Docker-Supported-blue)

Svalbard VaultDB é um sistema multimodelo desenvolvido para gerenciar o ciclo de vida completo de amostras botânicas armazenadas no Banco Mundial de Sementes de Svalbard (Ártico Norueguês)[cite: 3].

## 📌 Principais Funcionalidades

- **Isolamento "Caixa Preta" (RLS):** Garantia de direitos de propriedade intelectual por país via Row-Level Security nativa do PostgreSQL[cite: 4, 25].
- **Controle Concorrente de Capacidade:** Triggers em PL/pgSQL que impedem a alocação de lotes além da capacidade máxima da caixa física[cite: 4, 16].
- **Auditoria Imutável:** Bloqueio estrito de comandos `DELETE` e geração de logs auditáveis com hash SHA-256[cite: 4, 17, 18].
- **Otimização Física:** Organização de tabelas e índices em SSD/HDD via Tablespaces e indexação estratégica[cite: 21, 22].
- **Persistência Poliglota:** Integração complementar com Neo4j (grafos filogenéticos), MongoDB (especificações agrícolas) e InfluxDB (sensores IoT)[cite: 20, 28].

## 🚀 Como Executar o Ambiente via Docker

```bash
docker-compose up -d
