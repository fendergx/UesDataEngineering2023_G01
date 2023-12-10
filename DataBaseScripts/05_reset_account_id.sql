--funcion para calcular los balances de todas las cuentas de todas las empresas, para todas las fechas existentes en los registros.
--requiere la funcion CalcularSaldosDiarios() y de calculateAllSaldoInicialFinal() 
CREATE OR REPLACE FUNCTION refindAccount() RETURNS BOOLEAN AS $$
DECLARE
    query_text TEXT;
    id_val INT;
    company_id_val INT;
    account_id_val INT;
    account_code_val VARCHAR;
BEGIN
    -- Construir la consulta dinámica para obtener la lista de registros
    query_text := 'SELECT id,company_id,account_id,account_code FROM dw_account_sum WHERE account_id >45';

    -- Iterar los registros
    FOR id_val, company_id_val, account_id_val,account_code_val IN EXECUTE query_text
    LOOP
        -- Ejecutar para cada registro
        BEGIN
            UPDATE dw_account_sum 
            SET account_id = (SELECT account_id FROM dw_account_order WHERE account_code=account_code_val)
            WHERE id = id_val AND company_id = company_id_val;
        EXCEPTION
            WHEN OTHERS THEN
                -- Retorna falso en caso de error
                RETURN FALSE;
        END;
    END LOOP;
    -- Retornar true si es exitoso
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--ejecucion
--SELECT refindAccount();