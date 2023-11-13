--funcion que recibe de parametro un codigo de cuenta y retorna el codigo de cuenta padre si existe, sino retorna 0. se requiere la tabla dw_account_order
CREATE OR REPLACE FUNCTION findAccountParent(codigo_inicial VARCHAR, company INTEGER) RETURNS VARCHAR AS $$
DECLARE
    primer_digito VARCHAR;
    id_account INTEGER;
    id_account_parent INTEGER;
    sub6 VARCHAR;
    sub5 VARCHAR;
    sub4 VARCHAR;
    sub3 VARCHAR;
    sub2 VARCHAR;
BEGIN
	 id_account := (SELECT id FROM account_account WHERE company_id = company AND code = codigo_inicial);
    -- Obtener el primer dígito del código inicial
    primer_digito := LEFT(codigo_inicial, 1);
    -- generar los posibles codigos padre
    sub6 := LEFT(codigo_inicial, LENGTH(codigo_inicial) - 1) || '0';
    sub5 := LEFT(codigo_inicial, LENGTH(codigo_inicial) - 2) || '00';
    sub4 := LEFT(codigo_inicial, LENGTH(codigo_inicial) - 3) || '000';
    sub3 := LEFT(codigo_inicial, LENGTH(codigo_inicial) - 4) || '0000';
    sub2 := LEFT(codigo_inicial, LENGTH(codigo_inicial) - 5) || '00000';
	IF EXISTS (SELECT id,company_id,code FROM account_account WHERE company_id = company AND code = sub6 AND code!=codigo_inicial) THEN
			INSERT INTO dw_account_order (company_id,account_id,account_code,has_parent,account_parent_id,account_parent_code) VALUES (company,id_account,codigo_inicial,true,(SELECT id FROM account_account WHERE company_id=company AND code=sub6),sub6);
	    	RETURN sub6;
		END IF;
	IF EXISTS (SELECT id,company_id,code FROM account_account WHERE company_id = company AND code = sub5 AND code!=codigo_inicial) THEN
			INSERT INTO dw_account_order (company_id,account_id,account_code,has_parent,account_parent_id,account_parent_code) VALUES (company,id_account,codigo_inicial,true,(SELECT id FROM account_account WHERE company_id=company AND code=sub5),sub5);
	    	RETURN sub5;
		END IF;
	IF EXISTS (SELECT id,company_id,code FROM account_account WHERE company_id = company AND code = sub4 AND code!=codigo_inicial) THEN
			INSERT INTO dw_account_order (company_id,account_id,account_code,has_parent,account_parent_id,account_parent_code) VALUES (company,id_account,codigo_inicial,true,(SELECT id FROM account_account WHERE company_id=company AND code=sub4),sub4);
	    	RETURN sub4;
		END IF;
	IF EXISTS (SELECT id,company_id,code FROM account_account WHERE company_id = company AND code = sub3 AND code!=codigo_inicial) THEN
			INSERT INTO dw_account_order (company_id,account_id,account_code,has_parent,account_parent_id,account_parent_code) VALUES (company,id_account,codigo_inicial,true,(SELECT id FROM account_account WHERE company_id=company AND code=sub3),sub3);
	    	RETURN sub3;
		END IF;
	IF EXISTS (SELECT id,company_id,code FROM account_account WHERE company_id = company AND code = sub2 AND code!=codigo_inicial) THEN
			INSERT INTO dw_account_order (company_id,account_id,account_code,has_parent,account_parent_id,account_parent_code) VALUES (company,id_account,codigo_inicial,true,(SELECT id FROM account_account WHERE company_id=company AND code=sub2),sub2);
	    	RETURN sub2;
		END IF;
    -- Devolver 0 si no hay nada, e insertar el registro sin codigo padre
	INSERT INTO dw_account_order (company_id,account_id,account_code,has_parent,account_parent_id,account_parent_code) VALUES (company,id_account,codigo_inicial,false,NULL,NULL);
    RETURN '0';
END;
$$ LANGUAGE plpgsql;
--ejecucion
--SELECT findAccountParent('211100',1);
--SELECT findAccountParent('101000',1);
