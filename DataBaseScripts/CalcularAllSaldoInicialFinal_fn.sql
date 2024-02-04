--funcion que obtiene todos los registros que no se les ha calculado el saldo inicial y final, para posteriormente calcularlos
--esta funcion requiere de la funcion calcularSaldoInicialFinal(DATE,INT,INT,NUMERIC,NUMERIC)
CREATE OR REPLACE FUNCTION calculateAllSaldoInicialFinal() RETURNS BOOLEAN AS $$
DECLARE
    query_text TEXT;
    found_count INT := 0;
    updated_count INT := 0;
    --datos para iterar
    date_sum_val DATE;
    company_id_val INT;
    account_id_val INT;
    credit_val NUMERIC;
    debit_val NUMERIC;
BEGIN
    -- Construir la nueva consulta para obtener la lista de registros para validar
    query_text := 'SELECT date_sum,company_id,account_id,credit,debit
                    FROM dw_account_sum 
                    WHERE calculated_balance = FALSE
                    ORDER BY date_sum,company_id,account_id, ASC';
    -- Iterar sobre los registros de cuentas de sucursales.
    FOR date_sum_val, company_id_val, account_id_val, credit_val, debit_val IN EXECUTE query_text
    LOOP
        BEGIN
            --PERFORM calcularSaldoInicialFinal(id);
            -- Acceder a las columnas resultantes para mostrar en log
            RAISE NOTICE 'fecha: %, sucursal: %, account_id: %, credit: %, debit: %',date_sum_val, company_id_val, account_id_val,credit_val, debit_val;
            -- Incrementar el contador de registros encontrados
            found_count := found_count + 1;
            -- Ejecuta para cada registro calcularSaldoInicialFinal(fecha,company_id,account_id,credit,debit)
            PERFORM calcularSaldoInicialFinal(date_sum_val, company_id_val, account_id_val,credit_val, debit_val);
            -- Incrementar el contador de registros actualizados
            updated_count := updated_count + 1;
            EXCEPTION
            WHEN OTHERS THEN
                --Retorna falso en caso de error
                RETURN FALSE;
        END;
    END LOOP;
    -- Mostrando la información
    RAISE NOTICE '-------------------------------------------';
    IF found_count = 0 THEN
        RAISE NOTICE '0 registros encontrados, no se actualizarán los saldos.';
    ELSE 
        RAISE NOTICE 'Número total de registros encontrados: %', found_count;
        RAISE NOTICE 'Número total de registros actualizados: %', updated_count;
    END IF;
    -- Retornar true si es exitoso
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--ejecucion
--SELECT calculateAllSaldoInicialFinal();