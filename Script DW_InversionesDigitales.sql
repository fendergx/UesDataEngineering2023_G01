create database DW_InversionesDigitales
go

use DW_InversionesDigitales
go

create table DimFecha (
FechaKey int not null primary key, --Llave surrogada
Fecha smalldatetime not null, --Llave de negocio
Dia varchar(25),
DiaNumeroSemana int,
DiaNumeroMes int,
DiaNumeroAnio int,
Mes varchar(25),
MesNumero int,
NumeroSemanaMes int,
NumeroSemanaAnio int,
Trimestre varchar(25),
TrimestreNumero int,
Semestre varchar(25),
SemestreNumero int,
Anio int,
DiaLaboral varchar(10)
)
go

create table DimCuenta(
CuentaKey int identity(1,1) not null primary key, --Llave surrogada
CuentaId int not null,  --Llave de negocio
CodigoCuenta int,
CodigoCuentaPadre int,
NombreCuenta varchar(250),
TipoCuenta varchar(150),
GrupoCuenta varchar(150),
DescripcionCuenta varchar(150)
)
go

create table DimSucursal(
SucursalKey int identity(1,1) not null primary key, --Llave surrogada
SucursalId int not null,  --Llave de negocio
Nombre varchar(150)
)
go


-- *****************FACT TABLE:Transacciones Financieras *********************

create table FactTransaccionFinanciera(
FechaKey int not null,
CuentaKey int not null,
Sucursalkey int not null,
NumeroTransaccion int,
NumeroTransaccionDetalle int,
MontoCargo decimal(8,2),
MontoAbono decimal(8,2),
SaldoInicial decimal(8,2),
SaldoFinal decimal(8,2)
)
go

--> *****************TABLA TransaccionFinanciera - LLAVES PRIMARY Y FORANEAS*****************

--Llave primaria para FactTransaccionFinanciera
alter table FactTransaccionFinanciera add constraint TransaccionFinancieraPK primary key
(FechaKey, CuentaKey, SucursalKey)
go

--Llaves foraneas para FactTransaccionFinanciera

alter table FactTransaccionFinanciera add constraint Fecha_Transaccion_Financiera foreign key
(FechaKey) references DimFecha(FechaKey)
go

alter table FactTransaccionFinanciera add constraint Cuenta_Transaccion_Financiera foreign key
(CuentaKey) references DimCuenta(CuentaKey)
go

alter table FactTransaccionFinanciera add constraint Sucursal_Transaccion_Financiera foreign key
(SucursalKey) references DimSucursal(SucursalKey)
go