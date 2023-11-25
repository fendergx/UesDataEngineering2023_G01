--funcion que recibe de parametro un codigo de cuenta y retorna el codigo de cuenta padre si existe, sino retorna 0. se requiere la tabla dw_account_order
CREATE OR REPLACE FUNCTION findAccountParent(codigo_inicial VARCHAR, company INTEGER) RETURNS VARCHAR AS $$
DECLARE
    primer_digito VARCHAR;
    id_account INTEGER;
    id_account_parent INTEGER;
	name_account VARCHAR;
	type_account VARCHAR;
	group_account VARCHAR;
	parent_id_account INTEGER;
	parent_code_account VARCHAR;
	parent_name_account VARCHAR;
    sub6 VARCHAR;
    sub5 VARCHAR;
    sub4 VARCHAR;
    sub3 VARCHAR;
    sub2 VARCHAR;
BEGIN
	id_account := (SELECT id FROM account_account WHERE company_id = company AND code = codigo_inicial);
	name_account:=(SELECT name FROM account_account WHERE company_id = company AND code = codigo_inicial);
	type_account:=(SELECT account_type FROM account_account WHERE company_id = company AND code = codigo_inicial);
	group_account:=(SELECT internal_group FROM account_account WHERE company_id = company AND code = codigo_inicial);

    -- Obtener el primer dígito del código inicial
    primer_digito := LEFT(codigo_inicial, 1);
    -- generar los posibles codigos padre
    sub6 := LEFT(codigo_inicial, LENGTH(codigo_inicial) - 1) || '0';
    sub5 := LEFT(codigo_inicial, LENGTH(codigo_inicial) - 2) || '00';
    sub4 := LEFT(codigo_inicial, LENGTH(codigo_inicial) - 3) || '000';
    sub3 := LEFT(codigo_inicial, LENGTH(codigo_inicial) - 4) || '0000';
    sub2 := LEFT(codigo_inicial, LENGTH(codigo_inicial) - 5) || '00000';
	--nivel 6 al 2, con digitos con 0
	IF EXISTS (SELECT id,company_id,code FROM account_account WHERE company_id = company AND code = sub6 AND code!=codigo_inicial) THEN
			parent_id_account   :=(SELECT id FROM account_account WHERE company_id=company AND code=sub6);
			parent_code_account :=(SELECT code FROM account_account WHERE company_id=company AND code=sub6);
			parent_name_account :=(SELECT name FROM account_account WHERE company_id=company AND code=sub6);
			INSERT INTO dw_account_order (company_id,account_id,account_code,account_name,account_type,account_group,has_parent,parent_account_id,parent_account_code,parent_account_name) 
				VALUES (company,id_account,codigo_inicial,name_account,type_account,group_account,true,parent_id_account,sub6,parent_name_account);
		RETURN sub6;
		END IF;
	IF EXISTS (SELECT id,company_id,code FROM account_account WHERE company_id = company AND code = sub5 AND code!=codigo_inicial) THEN
			parent_id_account   :=(SELECT id FROM account_account WHERE company_id=company AND code=sub5);
			parent_code_account :=(SELECT code FROM account_account WHERE company_id=company AND code=sub5);
			parent_name_account :=(SELECT name FROM account_account WHERE company_id=company AND code=sub5);
			INSERT INTO dw_account_order (company_id,account_id,account_code,account_name,account_type,account_group,has_parent,parent_account_id,parent_account_code,parent_account_name) 
				VALUES (company,id_account,codigo_inicial,name_account,type_account,group_account,true,parent_id_account,sub5,parent_name_account);
		RETURN sub5;
		END IF;
	IF EXISTS (SELECT id,company_id,code FROM account_account WHERE company_id = company AND code = sub4 AND code!=codigo_inicial) THEN
			parent_id_account   :=(SELECT id FROM account_account WHERE company_id=company AND code=sub4);
			parent_code_account :=(SELECT code FROM account_account WHERE company_id=company AND code=sub4);
			parent_name_account :=(SELECT name FROM account_account WHERE company_id=company AND code=sub4);
			INSERT INTO dw_account_order (company_id,account_id,account_code,account_name,account_type,account_group,has_parent,parent_account_id,parent_account_code,parent_account_name) 
				VALUES (company,id_account,codigo_inicial,name_account,type_account,group_account,true,parent_id_account,sub4,parent_name_account);
		RETURN sub4;
		END IF;
	IF EXISTS (SELECT id,company_id,code FROM account_account WHERE company_id = company AND code = sub3 AND code!=codigo_inicial) THEN
			parent_id_account   :=(SELECT id FROM account_account WHERE company_id=company AND code=sub3);
			parent_code_account :=(SELECT code FROM account_account WHERE company_id=company AND code=sub3);
			parent_name_account :=(SELECT name FROM account_account WHERE company_id=company AND code=sub3);
			INSERT INTO dw_account_order (company_id,account_id,account_code,account_name,account_type,account_group,has_parent,parent_account_id,parent_account_code,parent_account_name) 
				VALUES (company,id_account,codigo_inicial,name_account,type_account,group_account,true,parent_id_account,sub3,parent_name_account);
		RETURN sub3;
		END IF;
	IF EXISTS (SELECT id,company_id,code FROM account_account WHERE company_id = company AND code = sub2 AND code!=codigo_inicial) THEN
			parent_id_account   :=(SELECT id FROM account_account WHERE company_id=company AND code=sub2);
			parent_code_account :=(SELECT code FROM account_account WHERE company_id=company AND code=sub2);
			parent_name_account :=(SELECT name FROM account_account WHERE company_id=company AND code=sub2);
			INSERT INTO dw_account_order (company_id,account_id,account_code,account_name,account_type,account_group,has_parent,parent_account_id,parent_account_code,parent_account_name) 
				VALUES (company,id_account,codigo_inicial,name_account,type_account,group_account,true,parent_id_account,sub2,parent_name_account);
		RETURN sub6;
		END IF;
    -- Devolver 0 si no hay nada, e insertar el registro sin codigo padre
	INSERT INTO dw_account_order (company_id,account_id,account_code,account_name,account_type,account_group,has_parent,parent_account_id,parent_account_code,parent_account_name)
		VALUES (company,id_account,codigo_inicial,name_account,type_account,group_account,false,NULL,NULL,NULL);
    RETURN '0';
END;
$$ LANGUAGE plpgsql;
--ejecucion
--SELECT findAccountParent('211100',1);
--SELECT findAccountParent('101000',1);
