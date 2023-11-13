--funcion para calcular saldos diarios, se requiere la tabla dw_account_sum
CREATE OR REPLACE FUNCTION calcularSaldosDiarios(fecha_consulta DATE DEFAULT NULL) RETURNS BOOLEAN AS $$
BEGIN
    -- Verificar si la fecha proporcionada es válida
    IF fecha_consulta IS NULL THEN
        RAISE EXCEPTION 'La fecha de consulta es requerida';
        RETURN FALSE;
    END IF;
   --elimina la tabla temporal por si existe, residuo de una ejecucion previa
    DROP TABLE IF EXISTS tablaTemporal;
    -- Crear una tabla temporal utilizando una consulta con WITH
    CREATE TEMPORARY TABLE tablaTemporal AS
    WITH DatosConsulta AS (
        SELECT date,company_id,account_id, SUM(credit) AS credito ,SUM(debit) AS debito,SUM(balance) AS balance
	    FROM account_move_line 
	    WHERE date = fecha_consulta
	    GROUP BY date,company_id,account_id ORDER BY company_id,account_id ASC
    )
    SELECT * FROM DatosConsulta;
    --limpiando informacion vieja
    DELETE FROM dw_account_sum WHERE fecha = fecha_consulta;
   -- SELECT pg_catalog.setval('dw_account_sum_id_seq', (SELECT max(id) FROM dw_account_sum), true);
    -- Insertar datos calculados en la tabla de destino desde la tabla temporal
    INSERT INTO dw_account_sum (fecha, id_empresa, id_cuenta, credito,debito,balance)
    SELECT *
    FROM tablaTemporal;
    -- Verificar si se insertaron filas correctamente
    IF FOUND THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

/* EJEMPLOS DE EJECUCION DE FUNCION */
--casos fallas
--SELECT calcularSaldosDiarios();
--SELECT calcularSaldosDiarios(null);
--caso ideal
--SELECT calcularSaldosDiarios('2023-07-09');
