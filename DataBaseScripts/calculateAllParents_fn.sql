--funcion para calcular todas las jerarquias de las cuentas de la base
--requiere la funcion findAccountParent()
CREATE OR REPLACE FUNCTION calculateAllParents() RETURNS BOOLEAN AS $$
DECLARE
    id INTEGER;
    code VARCHAR;
    id_company INTEGER;
    query_text TEXT;
BEGIN
    --borrar la informacion para limpiar
    DELETE FROM dw_account_order;
    ALTER SEQUENCE public.dw_account_order_id_seq RESTART 1;
    -- Construir la nueva consulta para obtener la lista de fechas
    query_text := 'SELECT id,code,company_id FROM account_account WHERE company_id = 1 ORDER BY company_id,code ASC';
    -- Iterar sobre los ids de la consulta
    FOR id IN EXECUTE query_text
    LOOP
        -- Ejecuta calcularSaldosDiarios para cada fecha
        BEGIN
            -- Obtener el código de la cuenta
            EXECUTE 'SELECT code FROM account_account WHERE id=' || id INTO code;
            -- Obtener el id_company de la cuenta
            EXECUTE 'SELECT company_id FROM account_account WHERE id=' || id INTO id_company;
            -- Llamar a la función findAccountParent con los valores obtenidos
            PERFORM findAccountParent(code, id_company);
        EXCEPTION
            WHEN OTHERS THEN
                -- retorna falso en caso de error
                RETURN FALSE;
        END;
    END LOOP;
    -- Retornar true si es exitoso
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--ejecucion
--SELECT calculateAllParents();