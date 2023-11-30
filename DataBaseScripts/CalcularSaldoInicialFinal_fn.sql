--funcion para calcular saldos iniciales y finales de los saldos diarios, se requiere la tabla dw_account_sum
CREATE OR REPLACE FUNCTION calcularSaldoInicialFinal(fecha_consulta DATE,idSucursal INT,idCuenta INT,credito NUMERIC,debito NUMERIC) RETURNS BOOLEAN AS $$
DECLARE
    saldoInicial NUMERIC;
    saldoFinal NUMERIC;
    record_count INT;
BEGIN
    -- Encontrar si hay registro menor a la fecha actual para la cuenta de la sucursal.
    SELECT COUNT(*)
    INTO record_count
    FROM dw_account_sum
    WHERE account_id = idCuenta AND company_id = idSucursal AND date_sum < fecha_consulta;
    --validando si es 0, actualizará el primer registro como saldo inicial 0 para la cuenta.
    IF record_count < 1 THEN
        saldoInicial := 0;
        saldoFinal := (debito-credito);
        UPDATE dw_account_sum SET initial_balance = saldoInicial, final_balance = saldoFinal,calculated_balance=true
            WHERE 
                account_id = idCuenta 
                AND company_id = idSucursal 
                AND date_sum = fecha_consulta 
                AND calculated_balance = FALSE;
    END IF;
    -- si es 1, actualizará el valor del credito y debito, tomando en cuenta los valores del ultimo registro (fecha anterior)
    IF record_count > 0 THEN
        saldoInicial := (SELECT final_balance 
                            FROM dw_account_sum 
                            WHERE account_id = idCuenta AND company_id = idSucursal AND date_sum < fecha_consulta 
                            ORDER BY id DESC LIMIT 1);
        saldoFinal := (saldoInicial + (debito-credito));
        UPDATE dw_account_sum SET initial_balance = saldoInicial, final_balance = saldoFinal,calculated_balance=true
            WHERE 
                account_id = idCuenta 
                AND company_id = idSucursal 
                AND date_sum = fecha_consulta 
                AND calculated_balance = FALSE;
    END IF;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

/* EJEMPLOS DE EJECUCION DE FUNCION */
--calcularSaldoInicialFinal(fecha,company_id,account_id,credit,debit);
--SELECT calcularSaldoInicialFinal('2023-07-08',1,14,5.75,200.25);