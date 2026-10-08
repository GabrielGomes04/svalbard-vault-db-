-- RN02: Controle de Capacidade Concorrente da Caixa
CREATE OR REPLACE FUNCTION verificar_capacidade_caixa()
RETURNS TRIGGER AS $$
DECLARE
    v_lotes_atuais INT;
    v_cap_maxima INT;
BEGIN
    IF NEW.ID_Caixa IS NOT NULL THEN
        SELECT COUNT(*)
        INTO v_lotes_atuais
        FROM LOTE_SEMENTES
        WHERE ID_Caixa = NEW.ID_Caixa
          AND ID_Lote IS DISTINCT FROM NEW.ID_Lote;

        SELECT Capacidade_Maxima
        INTO v_cap_maxima
        FROM CAIXA
        WHERE ID_Caixa = NEW.ID_Caixa;

        IF v_lotes_atuais >= v_cap_maxima THEN
            RAISE EXCEPTION 'Capacidade máxima da caixa % atingida. Limite: %. Lotes atuais: %.',
                NEW.ID_Caixa, v_cap_maxima, v_lotes_atuais;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verificar_capacidade_caixa
BEFORE INSERT OR UPDATE ON LOTE_SEMENTES
FOR EACH ROW
EXECUTE FUNCTION verificar_capacidade_caixa();

-- RN03: Imutabilidade dos Registros Historicos (Bloqueio de DELETE)
CREATE OR REPLACE FUNCTION bloquear_delete_lote()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Exclusão física proibida em LOTE_SEMENTES. Utilize UPDATE no campo Status para ''Inviavel'' ou ''Retirado''.';
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_bloquear_delete_lote
BEFORE DELETE ON LOTE_SEMENTES
FOR EACH ROW
EXECUTE FUNCTION bloquear_delete_lote();

CREATE OR REPLACE FUNCTION bloquear_delete_historico()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Exclusão física proibida em HISTORICO_ALOCACAO_CAIXA. Registros de rastreamento logístico são imutáveis.';
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_bloquear_delete_historico
BEFORE DELETE ON HISTORICO_ALOCACAO_CAIXA
FOR EACH ROW
EXECUTE FUNCTION bloquear_delete_historico();

CREATE OR REPLACE FUNCTION bloquear_delete_auditoria()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Exclusão física proibida em MOVIMENTACAO_AUDITORIA. Registros de auditoria são imutáveis por diretriz da ONU.';
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_bloquear_delete_auditoria
BEFORE DELETE ON MOVIMENTACAO_AUDITORIA
FOR EACH ROW
EXECUTE FUNCTION bloquear_delete_auditoria();

-- RN03 cont.: Registro Automatico de Auditoria ao Alterar Status
CREATE OR REPLACE FUNCTION registrar_auditoria_status()
RETURNS TRIGGER AS $$
DECLARE
    v_usuario_id INT;
    v_tipo_mov VARCHAR(30);
    v_hash_input TEXT;
BEGIN
    IF NEW.Status IN ('Inviavel', 'Retirado') AND OLD.Status IS DISTINCT FROM NEW.Status THEN
        v_usuario_id := current_setting('app.current_user_id', true)::INT;
        
        v_tipo_mov := CASE NEW.Status
            WHEN 'Inviavel' THEN 'Descarte Sanitario'
            WHEN 'Retirado' THEN 'Retirada'
        END;

        v_hash_input := NEW.ID_Lote::TEXT || v_tipo_mov || CURRENT_TIMESTAMP::TEXT;

        INSERT INTO MOVIMENTACAO_AUDITORIA (
            ID_Lote, ID_Usuario, Tipo_Movimentacao, Data_Hora, Assinatura_Digital_Hash
        ) VALUES (
            NEW.ID_Lote, v_usuario_id, v_tipo_mov, CURRENT_TIMESTAMP, encode(sha256(v_hash_input::bytea), 'hex')
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_auditoria_status_lote
AFTER UPDATE OF Status ON LOTE_SEMENTES
FOR EACH ROW
WHEN (OLD.Status IS DISTINCT FROM NEW.Status)
EXECUTE FUNCTION registrar_auditoria_status();
