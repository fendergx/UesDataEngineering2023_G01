--funcion que recibe de parametro un codigo de cuenta y retorna el codigo de cuenta padre si existe, sino retorna 0.
CREATE OR REPLACE FUNCTION findAccountParent(codigo_inicial VARCHAR, company INTEGER)
RETURNS VARCHAR AS
$$
DECLARE
    primer_digito VARCHAR;
    id_account INTEGER;
    sub6 VARCHAR;
    sub5 VARCHAR;
    sub4 VARCHAR;
    sub3 VARCHAR;
    sub2 VARCHAR;
begin
	 id_account := (SELECT id FROM account_account where company_id = company AND code = codigo_inicial);
    -- Obtener el primer dígito del código inicial
    primer_digito := LEFT(codigo_inicial, 1);
    -- generar los posibles codigos padre
    sub6 := LEFT(codigo_inicial, LENGTH(codigo_inicial) - 1) || '0';
    sub5 := LEFT(codigo_inicial, LENGTH(codigo_inicial) - 2) || '00';
    sub4 := LEFT(codigo_inicial, LENGTH(codigo_inicial) - 3) || '000';
    sub3 := LEFT(codigo_inicial, LENGTH(codigo_inicial) - 4) || '0000';
    sub2 := LEFT(codigo_inicial, LENGTH(codigo_inicial) - 5) || '00000';
	IF EXISTS (SELECT id,company_id,code FROM account_account WHERE company_id = company AND code = sub6 and code!=codigo_inicial) THEN
	    	RETURN sub6;
		END IF;
	IF EXISTS (SELECT id,company_id,code FROM account_account WHERE company_id = company AND code = sub5 and code!=codigo_inicial) THEN
	    	RETURN sub5;
		END IF;
	IF EXISTS (SELECT id,company_id,code FROM account_account WHERE company_id = company AND code = sub4 and code!=codigo_inicial) THEN
	    	RETURN sub4;
		END IF;
	IF EXISTS (SELECT id,company_id,code FROM account_account WHERE company_id = company AND code = sub3 and code!=codigo_inicial) THEN
	    	RETURN sub3;
		END IF;
	IF EXISTS (SELECT id,company_id,code FROM account_account WHERE company_id = company AND code = sub2 and code!=codigo_inicial) THEN
	    	RETURN sub2;
		END IF;
    -- Devolver 0 si no hay nada
    RETURN '0';
END;
$$ LANGUAGE plpgsql;
--ejecucion
--select findAccountParent('211100');