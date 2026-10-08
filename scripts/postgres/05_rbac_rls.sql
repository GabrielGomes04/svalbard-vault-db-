-- Criacao de Roles
CREATE ROLE role_administrador;
CREATE ROLE role_representante;
CREATE ROLE role_auditor_onu;

-- Privilegios do Administrador
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO role_administrador;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO role_administrador;

-- Privilegios do Representante
GRANT SELECT, INSERT ON LOTE_SEMENTES TO role_representante;
GRANT SELECT ON CATEGORIA_TAXONOMICA, INSTITUICAO, CAIXA TO role_representante;
GRANT SELECT ON MOVIMENTACAO_AUDITORIA TO role_representante;

-- Privilegios do Auditor ONU
GRANT SELECT ON ALL TABLES IN SCHEMA public TO role_auditor_onu;

-- Criacao de Usuarios Concretos
CREATE USER admin_erik WITH PASSWORD 'S@ltvault#2024!Erik';
CREATE USER repr_carlos WITH PASSWORD 'S@ltvault#2024!Carlos';
CREATE USER auditor_onu_001 WITH PASSWORD 'S@ltvault#2024!ONU01';

GRANT role_administrador TO admin_erik;
GRANT role_representante TO repr_carlos;
GRANT role_auditor_onu TO auditor_onu_001;

-- Habilitar Row-Level Security (RLS)
ALTER TABLE LOTE_SEMENTES ENABLE ROW LEVEL SECURITY;
ALTER TABLE MOVIMENTACAO_AUDITORIA ENABLE ROW LEVEL SECURITY;

-- Politicas RLS para LOTE_SEMENTES
CREATE POLICY politica_caixa_preta_select ON LOTE_SEMENTES
FOR SELECT TO role_representante
USING (
    ID_Depositante = (
        SELECT r.ID_Depositante 
        FROM REPRESENTANTE r 
        JOIN USUARIO u ON r.ID_Usuario = u.ID_Usuario 
        WHERE u.Login = current_user
    )
);

CREATE POLICY politica_caixa_preta_insert ON LOTE_SEMENTES
FOR INSERT TO role_representante
WITH CHECK (
    ID_Depositante = (
        SELECT r.ID_Depositante 
        FROM REPRESENTANTE r 
        JOIN USUARIO u ON r.ID_Usuario = u.ID_Usuario 
        WHERE u.Login = current_user
    )
);

-- Politica RLS para MOVIMENTACAO_AUDITORIA
CREATE POLICY politica_auditoria_representante ON MOVIMENTACAO_AUDITORIA
FOR SELECT TO role_representante
USING (
    ID_Lote IN (
        SELECT ls.ID_Lote 
        FROM LOTE_SEMENTES ls 
        JOIN REPRESENTANTE r ON ls.ID_Depositante = r.ID_Depositante 
        JOIN USUARIO u ON r.ID_Usuario = u.ID_Usuario 
        WHERE u.Login = current_user
    )
);

-- Bypass RLS para administradores e auditores da ONU
ALTER TABLE LOTE_SEMENTES FORCE ROW LEVEL SECURITY;
ALTER ROLE role_administrador BYPASSRLS;
ALTER ROLE role_auditor_onu BYPASSRLS;
