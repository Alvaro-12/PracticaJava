-- Creación de la base de datos
-- COMANDOS A USAR DDL Data Definition Language
Use master
Go -- separación de bloques de código
-- Comando disponible solo  en la version 2016 >
Drop database if exists Salarios
Go
Create database Salarios
Go
Use Salarios
Go


Create Table Cargos(
	IdCargo int primary key identity(1,1) not null,
	Nombre varchar(50),
	SueldoBruto Money,
	ISSS decimal(5,2),
	AFP decimal(5,2)
	
);

Insert into Cargos values ('Gerente',1000,15,10),('Vendedor',400,15,10);

Create Table Empleados(
	IdEmpleado int primary key identity(1,1) not null,
	Nombre varchar(100)
);

Insert into Empleados values ('Jaime Perez'),('Maria Hernandez'),('Jorge Gomez');

Create Table Contratos(
	IdContrato int primary key identity(1,1) not null,
	Fecha Date,
	IdEmpleado_FK int not null Foreign key References Empleados(IdEmpleado),
	IdCargo_FK int not null Foreign key References Cargos(IdCargo)
	--Faltan mas columnas
);

Insert into Contratos values ('01/01/2020',1,1),('09/01/2020',2,2),('09/01/2020',3,2)

Create Table Pagos(
	IdPago int primary key identity(1,1) not null,
	Fecha Date,
	HorasExtras money,
	Bono money,
	IdContrato_FK int not null Foreign key References Contratos(IdContrato),
	--Faltan mas columnas
);

Insert into Pagos values
				--Mes de  septiembre
				('09/30/2020',0,10,1),('09/30/2020',50,10,2),('09/30/2020',50,50,3),
				--Mes de  Octubre
				('10/30/2020',0,0,1),('10/30/2020',150,0,2),('10/30/2020',0,0,3)

Go

-- Consultas a realizar.
-- 1- Listado de empleados y el cargo que desempeñan
   
Select b.Nombre as Empleado, c.Nombre as Cargo from Contratos as a
			inner join Empleados as b on a.IdEmpleado_FK=b.IdEmpleado
			inner join Cargos as c on a.IdCargo_FK=c.IdCargo

-- 2- A la consulta anterior, agregue el tiempo en días que tienen de haber sido contratados
select b.Nombre as Empleado, c.Nombre as Cargos, a.Fecha as [Dia de Contratacion] from Contratos as a
            inner join Empleados as b on a.IdEmpleado_FK=b.IdEmpleado
            inner join Cargos as c on a.IdCargo_FK=c.IdCargo

-- 3- A la primer consulta, indique el sueldo bruto que ganan
Select b.Nombre as Empleado, c.Nombre as Cargo,c.SueldoBruto as [Sueldo Bruto] from Contratos as a
			inner join Empleados as b on a.IdEmpleado_FK=b.IdEmpleado
			inner join Cargos as c on a.IdCargo_FK=c.IdCargo 

-- 4- A la consulta anterior agregue los descuentos realizados y calcule el sueldo liquido(sueldo ya con descuentos)
select b.Nombre as Empleado, c.Nombre as Cargos, c.SueldoBruto as Sueldo_Bruto,c.AFP , c.ISSS , c.SueldoBruto-c.ISSS-c.AFP as Sueldo_Liquido from Contratos as a
            inner join Empleados as b on a.IdEmpleado_FK=b.IdEmpleado
            inner join Cargos as c on a.IdCargo_FK=c.IdCargo 

-- 5- Listado de empleados excluyendo los que tengan el cargo Gerente
select  b.Nombre as Nombre,c.Nombre as cargo from Contratos as a
            inner join Empleados as b on a.IdEmpleado_FK=b.IdEmpleado
            inner join Cargos as c on a.IdCargo_FK=c.IdCargo
where c.IdCargo != 1

-- 6- Listado de empleados excluyendo los que tengan el cargo Vendedor
select  b.Nombre as Nombre,c.Nombre as cargo from Contratos as a
            inner join Empleados as b on a.IdEmpleado_FK=b.IdEmpleado
            inner join Cargos as c on a.IdCargo_FK=c.IdCargo
where c.IdCargo != 2

-- 7- Realice una consulta que retorne el sueldo que gano cada empleado el mes de septiembre
select n.Nombre, s.SueldoBruto, s.AFP, s.ISSS, f.Bono, f.HorasExtras, s.SueldoBruto-AFP-ISSS+f.Bono+f.HorasExtras as Sueldo_Liquido, f.Fecha from Contratos d 
           inner join Empleados as n on d.IdEmpleado_FK = n.IdEmpleado
           inner join Cargos as s on d.IdCargo_FK = s.IdCargo
inner join Pagos as f on d.IdContrato = f.IdContrato_FK
Where f.Fecha = '2020-09-30'

-- 8- Realice una consulta que retorne el sueldo que gano cada empleado el mes de octubre
select n.Nombre, s.SueldoBruto, s.AFP, s.ISSS, f.Bono, f.HorasExtras, s.SueldoBruto-AFP-ISSS+f.Bono+f.HorasExtras as Sueldo_Liquido, f.Fecha from Contratos d 
           inner join Empleados as n on d.IdEmpleado_FK = n.IdEmpleado
           inner join Cargos as s on d.IdCargo_FK = s.IdCargo
           inner join Pagos as f on d.IdContrato = f.IdContrato_FK
Where f.Fecha = '2020-10-30'

-- 9- Qué empleado tuvo mejor salario en Septiembre
select n.Nombre, s.SueldoBruto, s.AFP, s.ISSS, f.Bono, f.HorasExtras, MAX(s.SueldoBruto-AFP-ISSS+f.Bono+f.HorasExtras) as Sueldo_Liquido, f.Fecha from Contratos d 
           inner join Empleados as n on d.IdEmpleado_FK = n.IdEmpleado
           inner join Cargos as s on d.IdCargo_FK = s.IdCargo
           inner join Pagos as f on d.IdContrato = f.IdContrato_FK
Where f.Fecha = '2020-09-30'
group by n.Nombre, s.SueldoBruto, s.AFP, s.ISSS, f.Bono, f.HorasExtras,f.Fecha
order by (Sueldo_Liquido) DESC;
-- 10- Qué empleado obtuvo la mayor cantidad de horas extras en octubre
select n.Nombre,  MAX (f.HorasExtras), f.Fecha from Contratos d 
           inner join Empleados as n on d.IdEmpleado_FK = n.IdEmpleado
           inner join Cargos as s on d.IdCargo_FK = s.IdCargo
           inner join Pagos as f on d.IdContrato = f.IdContrato_FK
Where f.Fecha = '2020-10-30' 
group by n.Nombre, f.HorasExtras,f.Fecha
order by (f.HorasExtras) DESC;




