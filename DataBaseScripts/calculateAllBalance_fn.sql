--funcion para calcular los balances de todas las cuentas de todas las empresas, para todas las fechas existentes en los registros.
--requiere la funcion CalcularSaldosDiarios() y de calculateAllSaldoInicialFinal() 
CREATE OR REPLACE FUNCTION calculateAllBalance() RETURNS BOOLEAN AS $$
DECLARE
    fecha_actual DATE;
    query_text TEXT;
    fecha_min DATE;
    fecha_max DATE;
BEGIN
    -- Obtener las fechas mínima y máxima
    fecha_min := (SELECT DISTINCT date FROM account_move_line ORDER BY date ASC LIMIT 1);
    fecha_max := (SELECT DISTINCT date FROM account_move_line ORDER BY date DESC LIMIT 1);

    -- Construir la consulta dinámica para obtener la lista de fechas
    query_text := 'SELECT generate_series(date ''' || fecha_min || ''', date ''' || fecha_max || ''', interval ''1 day'' day)';

    -- Iterar sobre las fechas de la consulta
    FOR fecha_actual IN EXECUTE query_text
    LOOP
        -- Ejecutar calcularSaldosDiarios para cada fecha
        BEGIN
            PERFORM calcularSaldosDiarios(fecha_actual);
            RAISE NOTICE '%', fecha_actual;
        EXCEPTION
            WHEN OTHERS THEN
                -- Retorna falso en caso de error
                RETURN FALSE;
        END;
    END LOOP;

    -- Calcular los saldos iniciales y finales
    PERFORM calculateAllSaldoInicialFinal();
    -- Retornar true si es exitoso
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--ejecucion
--SELECT calculateAllBalance();