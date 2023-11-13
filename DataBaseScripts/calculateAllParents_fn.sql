--funcion para calcular todas las jerarquias de las cuentas de la base
--requiere la funcion findAccountParent()
CREATE OR REPLACE FUNCTION calculateAllParents() RETURNS BOOLEAN AS $$
DECLARE
    id INTEGER;
    query_text TEXT;
BEGIN
    -- Construir la nueva consulta para obtener la lista de fechas
    query_text := 'SELECT id,code,company_id FROM account_account ORDER BY id ASC';
    -- Iterar sobre los ids de la consulta
    FOR id IN EXECUTE query_text
    LOOP
        -- Ejecuta calcularSaldosDiarios para cada fecha
        BEGIN
            PERFORM findAccountParent(code,company_id);
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