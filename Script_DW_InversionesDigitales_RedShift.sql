--/* clean tables */
--https://us-east-2.console.aws.amazon.com/sqlworkbench/home?region=us-east-2#/client
--drop TABLE IF EXISTS facttransaccionfinanciera;
--drop TABLE IF EXISTS dimcuenta;
--drop TABLE IF EXISTS dimsucursal;
--drop TABLE IF EXISTS dimfecha;

--dimension de dimsucursal
CREATE TABLE dimsucursal(
        sucursalKey int PRIMARY KEY,
        sucursalId int distkey,
        nombre varchar(150)
)sortKey(sucursalKey);

--dimension de cuenta
CREATE TABLE dimcuenta(
        cuentaKey int PRIMARY KEY,
        cuentaId int distkey,
        codigoCuenta int,
        nombreCuenta varchar(250),
        --codigoCuentaPadre int,
        tipoCuenta varchar(150),
        grupoCuenta varchar(150),
        descripcionCuenta varchar(150)
)sortKey(cuentaKey);

--dimension de fecha
CREATE TABLE dimfecha(
    fechakey int PRIMARY KEY distkey, --formato iso
    fecha varchar(10),
    dia varchar(25),
    diaNumeroSemana int,
    diaNumeroMes int,
    diaNumeroAnio int,
    mes varchar(25),
    mesNumero int,
    numeroSemanaMes int,
    numeroSemanaAnio int,
    trimestre varchar(25),
    trimestreNumero int,
    semestre varchar(25),
    semestreNumero int,
    anio int,
    diaLaboral varchar(10)
)sortKey(fechakey, mes, anio);

--fact table de transacciones finacieras
CREATE TABLE facttransaccionfinanciera(
    fechaKey int,
    cuentaKey int,
    sucursalKey int,
    numeroTransaccion int, --account_move
    numeroTransaccionDetalle int, --account_move_line
    montoCargo numeric(8,2),
    montoAbono numeric(8,2),
    balance numeric(8,2),
    saldoInicial numeric(8,2),
    saldoFinal numeric(8,2),
    FOREIGN KEY(cuentaKey) REFERENCES dimcuenta(cuentaKey),
	FOREIGN KEY(sucursalKey) REFERENCES dimsucursal(sucursalKey),
	FOREIGN KEY(fechaKey) REFERENCES dimfecha(fechaKey)
)sortKey(cuentaKey,sucursalKey, fechaKey);
