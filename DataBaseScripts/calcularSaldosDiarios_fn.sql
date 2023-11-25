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
        SELECT t01.date,t01.company_id,t03.name AS company_name,t01.account_id,t02.code AS account_code,t02.name AS account_name, SUM(t01.credit) AS credito ,SUM(t01.debit) AS debito,SUM(t01.balance) AS balance
        FROM account_move_line AS t01
        INNER JOIN account_account AS t02 ON t01.account_id  = t02.id
        INNER JOIN res_company AS t03 ON t01.company_id = t03.id
        WHERE date = fecha_consulta
        GROUP BY date,t01.company_id,t03.name,t01.account_id,t02.code,t02.name ORDER BY t01.company_id,t01.account_id ASC
    )
    SELECT * FROM DatosConsulta;
    --limpiando informacion vieja
    DELETE FROM dw_account_sum WHERE date_sum = fecha_consulta;
    -- SELECT pg_catalog.setval('dw_account_sum_id_seq', (SELECT max(id) FROM dw_account_sum), true);
    -- Insertar datos calculados en la tabla de destino desde la tabla temporal
    INSERT INTO dw_account_sum (date_sum, company_id,company_name,account_id,account_code,account_name,credit,debit,balance)
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
