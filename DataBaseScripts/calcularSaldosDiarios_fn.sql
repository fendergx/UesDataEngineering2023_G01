CREATE OR REPLACE FUNCTION calcularSaldosDiarios(fecha_consulta DATE DEFAULT NULL) RETURNS BOOLEAN AS $$
DECLARE
    contador INTEGER;
    companies INT;
    cuentasCount TEXT;
    cuenta_code TEXT;
    existe INT;
    query_text_activo TEXT;
    query_text_pasivo TEXT;
    company_val INT;
    credit_val FLOAT;
    debit_val FLOAT;
    balance_val FLOAT;
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
    contador :=(SELECT count(*) FROM tablaTemporal);
    RAISE NOTICE 'Número total de registros encontrados: %', contador; 
    --limpiando informacion vieja
    DELETE FROM dw_account_sum WHERE date_sum = fecha_consulta;
    -- SELECT pg_catalog.setval('dw_account_sum_id_seq', (SELECT max(id) FROM dw_account_sum), true);
    -- Insertar datos calculados en la tabla de destino desde la tabla temporal
    INSERT INTO dw_account_sum (date_sum, company_id,company_name,account_id,account_code,account_name,credit,debit,balance)
    SELECT *
    FROM tablaTemporal;
    --insertar los demas valores
    FOR companies IN SELECT generate_series(1, 5) LOOP
        -- Hacer algo con el valor de companies
        RAISE NOTICE 'Iterador: %', companies;
        --trae todos los codigos de cuentas del catalogo
        cuentasCount := 'select account_code from dw_account_order';
        -- Iterar sobre los registros de cuentas de sucursales.
        FOR cuenta_code IN EXECUTE cuentasCount
        LOOP
            BEGIN
                --PERFORM calcularSaldoInicialFinal(id);
                -- Acceder a las columnas resultantes para mostrar en log
                RAISE NOTICE 'account_code: %',cuenta_code;
            existe := (select count(*) from dw_account_sum where date_sum=fecha_consulta and account_code=cuenta_code and company_id=companies);
                    IF existe = 1 THEN
                        RAISE NOTICE '1 registros encontrado, no se actualizarán los saldos.';
                    ELSE 
                            INSERT INTO dw_account_sum 
                            (date_sum, company_id,company_name,account_id,account_code,account_name,credit,debit,balance)
                            values(
                                fecha_consulta,
                                companies,
                                (select name from res_company where id=companies),
                                (select account_id from dw_account_order where account_code=cuenta_code),
                                cuenta_code,
                                (select account_name from dw_account_order where account_code=cuenta_code),
                                0,0,0);
                    END IF;
            END;
            --cuenta_code fin loop
        END LOOP; 
        -- Reindizar los id's de cuenta en dw_account_sum (buscar el id account)
        PERFORM refindAccount();
        -- calcula el resumen de activo corriente (asset_current)
        query_text_activo :='SELECT t01.company_id,SUM(credit) AS credit, S(debit) AS debit,sum(balance) as balance from dw_account_sum t01
            inner join dw_account_order t02
            on t02.account_id =t01.account_id
            where t01.company_id =''' || companies || '''
            and date_sum=''' || fecha_consulta || '''
            and t02.account_type =''asset_current'' and t02.account_code not in (''101000'')
            group by t01.company_id
            ';
        FOR company_val,credit_val,debit_val,balance_val IN EXECUTE query_text_activo
        LOOP
            BEGIN
                update dw_account_sum set credit=credit_val,debit=debit_val,balance=balance_val
                where company_id =companies and account_code ='101000' and date_sum =fecha_consulta;
            END;
        END LOOP;
        -- calcula el resumen de pasivo corriente (liability_current)
        query_text_pasivo :='select t01.company_id,sum(credit) as credit, sum(debit) as debit,sum(balance) as balance from dw_account_sum t01
            inner join dw_account_order t02
            on t02.account_id =t01.account_id
            where t01.company_id =''' || companies || '''
            and date_sum=''' || fecha_consulta || '''
            and t02.account_type =''liability_current'' and t02.account_code not in (''201000'')
            group by t01.company_id
            ';
        FOR company_val,credit_val,debit_val,balance_val IN EXECUTE query_text_pasivo
        LOOP
            BEGIN
                update dw_account_sum set credit=credit_val,debit=debit_val,balance=balance_val
                where company_id =companies and account_code ='201000' and date_sum =fecha_consulta;
            END;
        END LOOP;
        --fin iteracion sucursal
    END LOOP;

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
