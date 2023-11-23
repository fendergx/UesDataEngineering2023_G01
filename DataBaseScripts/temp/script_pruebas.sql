/* SCRIPTS PARA PRUEBAS EN BASE DE DATOS*/

--catalogo cuentas, ordenados por codigo
select id,name,code,account_type,internal_group from account_account where company_id =1 order by code asc;

/* PROBANDO FUNCIONES DE TABLAS DW NUEVAS */
select calcularSaldosDiarios('2023-07-07');

--SELECT DISTINCT date FROM account_move_line ORDER BY date asc;

SELECT calculateAllBalance();

select findAccountParent('101300',1);
select findAccountParent('101000',1);
--101300 - 6
--101300 - 5
--101000 - 4
--100000 - 3
--100000 - 2
select calculateAllParents();

/* PRUEBAS DE IMPUESTOS IVA */
--los resumen de impuestos estan en account_move
--movimientos de Taxes recibidos (Venta IVA 13%)
select * from account_move_line where account_id in (select id from account_account where code in ('251000'));
--movimientos de Taxes recibidos (Compra IVA 13%)
select * from account_move_line where account_id in (select id from account_account where code in ('131000'));