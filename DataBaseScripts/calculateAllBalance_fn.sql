--funcion para calcular los balances de todas las cuentas de todas las empresas, para todas las fechas existentes en los registros.
--requiere la funcion CalcularSaldosDiarios()
CREATE OR REPLACE FUNCTION calculateAllBalance() RETURNS BOOLEAN AS $$
DECLARE
    fecha_actual DATE;
    query_text TEXT;
BEGIN
    -- Construir la nueva consulta para obtener la lista de fechas
    query_text := 'SELECT DISTINCT date FROM account_move_line ORDER BY date ASC';
    -- Iterar sobre las fechas de la consulta
    FOR fecha_actual IN EXECUTE query_text
    LOOP
        -- Ejecuta calcularSaldosDiarios para cada fecha
        BEGIN
            PERFORM calcularSaldosDiarios(fecha_actual);
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
--SELECT calculateAllBalance();