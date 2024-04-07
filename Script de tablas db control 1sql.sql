CREATE DATABASE "BDA-control1"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;


create table Cliente(
	id_cliente serial primary key,
	nombre_cliente varchar(200),
	nacionalidad_cliente varchar(200)
);


create table Sueldo (
	id_sueldo serial primary key,
	monto_sueldo int,
	fecha_pago_sueldo Date
);


create table Empleado (
	id_empleado serial primary key,
	nombre_empleado varchar(200),
	cargo_empleado varchar(200),
	id_sueldo integer,
	FOREIGN KEY (id_sueldo) REFERENCES Sueldo(id_sueldo)
);



create table Compañia (
	id_compañia serial primary key,
	nombre_compañia varchar(200),
	id_empleado integer,
	FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

create table Cliente_compañia (
	id_cliente_compañia serial primary key,
	id_cliente integer,
	id_compañia integer,
	FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
	FOREIGN KEY (id_compañia) REFERENCES Compañia(id_compañia)
);

create table Modelo(
	id_modelo serial primary key,
	nombre_modelo varchar (200)
);

create table Avion (
	id_avion serial primary key,
	itinerario_avion varchar(200),
	vuelos_avion int,
	id_compañia integer,
	id_modelo integer,
	FOREIGN KEY (id_compañia) REFERENCES Compañia(id_compañia),
	FOREIGN KEY (id_modelo) REFERENCES Modelo(id_modelo)
);

create table Vuelo(
	id_vuelo serial primary key,
	id_compañia integer,
	id_avion integer,
	FOREIGN KEY (id_compañia) REFERENCES Compañia(id_compañia),
	FOREIGN KEY (id_avion) REFERENCES Avion(id_avion)
);


create table Cliente_vuelo(
	id_cliente_vuelo serial primary key,
	id_cliente integer,
	id_vuelo integer,
	FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
	FOREIGN KEY (id_vuelo) REFERENCES Vuelo(id_vuelo)
);




create table Emp_vuelo(
	id_emp_vuelo serial primary key,
	id_vuelo integer,
	id_empleado integer,
	FOREIGN KEY (id_vuelo) REFERENCES Vuelo(id_vuelo),
	FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);


create table Seccion (
	id_seccion serial primary key,
	nombre_seccion varchar(200)
);

create table Costo(
	id_costo serial primary key,
	valor_costo int
);

create table Pasaje(
	id_pasaje serial primary key,
	fecha_pasaje Date,
	origen_pasaje varchar(200),
	destino_pasaje varchar(200),
	id_vuelo integer,
	id_costo integer,
	id_seccion integer,
	FOREIGN KEY (id_vuelo) REFERENCES Vuelo(id_vuelo),
	FOREIGN KEY (id_costo) REFERENCES Costo(id_costo),
	FOREIGN KEY (id_seccion) REFERENCES Seccion(id_seccion)
);


