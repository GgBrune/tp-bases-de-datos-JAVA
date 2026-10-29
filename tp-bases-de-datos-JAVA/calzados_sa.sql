-- CREACIÓN DE LA BASE DE DATOS:
CREATE DATABASE /*!32312 IF NOT EXISTS*/ calzados_sa;
USE calzados_sa;

-- VERIFICACIÓN DE EXISTENCIA DE TABLAS:
DROP TABLE IF EXISTS Trabajo;
DROP TABLE IF EXISTS Vta_Zapato;
DROP TABLE IF EXISTS Provee;
DROP TABLE IF EXISTS PCel;
DROP TABLE IF EXISTS Minorista;
DROP TABLE IF EXISTS Mayorista;
DROP TABLE IF EXISTS Franco;
DROP TABLE IF EXISTS Venta;
DROP TABLE IF EXISTS Stock;
DROP TABLE IF EXISTS Fecha;
DROP TABLE IF EXISTS Talla;
DROP TABLE IF EXISTS Proveedor;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Vendedor;
DROP TABLE IF EXISTS Zapato;
DROP TABLE IF EXISTS Auditoria_Zapato;

-- TABLA ZAPATO:
CREATE TABLE Zapato
(
	modelo VARCHAR(100) NOT NULL,
	color VARCHAR(100) NOT NULL,
	precio DOUBLE NOT NULL,
	PRIMARY KEY (modelo, color),
	CONSTRAINT limite_precio CHECK (precio > 0 AND precio < 200000)
);
-- VALORES -> ZAPATO:
INSERT INTO Zapato VALUES
('Zapatilla', 'Blanco', 30000),
('Alpargata', 'Marrón', 1000),
('Chancleta', 'Rosa', 20000);

-- TABLA TALLA:
CREATE TABLE Talla
(
	numero INTEGER NOT NULL PRIMARY KEY 
);
-- VALORES -> TALLA:
INSERT INTO Talla VALUES
(39),
(38),
(37);

-- TABLA CLIENTE:
CREATE TABLE Cliente
(
	dni_cliente INTEGER NOT NULL PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL,
	apellido VARCHAR(100) NOT NULL,
	direccion VARCHAR(100) NOT NULL
);
-- VALORES -> CLIENTE:
INSERT INTO Cliente VALUES
(20854910, 'Carmela', 'Altamirano', 'Roque Saenz Peña 1600'),
(45254891, 'Maxima', 'Gonzalez', 'Blas Parera 1276'),
(15456308, 'Iñaqui', 'Torres', 'Martires Riocuartenses 1070');

-- TABLA VENDEDOR:
CREATE TABLE Vendedor
(
	dni_vendedor INTEGER NOT NULL PRIMARY KEY, 
	nombre VARCHAR(100),
	apellido VARCHAR(100),
	direccion VARCHAR(100),
	nro_vendedor INTEGER NOT NULL AUTO_INCREMENT UNIQUE
);
-- VALORES -> VENDEDOR:
INSERT INTO Vendedor (dni_vendedor, nombre, apellido, direccion) VALUES
(40789120, 'Joaquin', 'Rodriguez', 'Moreno 408'),
(23478029, 'Milena', 'Romero', 'San Martin 800'),
(43566778, 'Mabel', 'Castillo', 'Constitución 210');

-- TABLA VENTA:
CREATE TABLE Venta
(
	cod_venta INTEGER NOT NULL PRIMARY KEY,
	nro_factura INTEGER NOT NULL,
	fecha DATE NOT NULL,
	monto INTEGER NOT NULL,
	dni_vendedor INTEGER NOT NULL,
	dni_cliente INTEGER NOT NULL,
	dto_venta INTEGER NOT NULL,
	CONSTRAINT desc_cons CHECK (0 <= dto_venta AND dto_venta <= 100),
	FOREIGN KEY (dni_cliente) REFERENCES Cliente (dni_cliente) ON DELETE RESTRICT,
	FOREIGN KEY (dni_vendedor) REFERENCES Vendedor (dni_vendedor) ON DELETE RESTRICT
);
-- VALORES -> VENTA:
INSERT INTO Venta VALUES
(089, 0000100000567, '2024-07-02', 53000, 40789120, 20854910, 20),
(090, 0000100000568, '2024-08-05', 20567, 23478029, 45254891, 50),
(091, 0000100000569, '2024-09-07', 91500, 43566778, 15456308, 10);

-- TABLA MINORISTA:
CREATE TABLE Minorista
(
	dni_cliente INTEGER NOT NULL PRIMARY KEY,
	fcha_nacimiento DATE NOT NULL,
    FOREIGN KEY (dni_cliente) REFERENCES Cliente (dni_cliente) ON DELETE CASCADE
);
-- VALORES -> MINORISTA:
INSERT INTO Minorista VALUES 
(20854910, '1978-05-15'),
(45254891, '2004-07-20');

-- TABLA MAYORISTA:
CREATE TABLE Mayorista
(
	dni_cliente INTEGER NOT NULL PRIMARY KEY,
	dto_general INTEGER NOT NULL,
	CONSTRAINT dto_cons CHECK (0 <= dto_general AND dto_general <= 100),
	FOREIGN KEY (dni_cliente) REFERENCES Cliente (dni_cliente) ON DELETE CASCADE
);
-- VALORES -> MAYORISTA:
INSERT INTO Mayorista VALUES
(15456308, 30);

-- TABLA FRANCO:
CREATE TABLE Franco
(
	nro_franco INTEGER NOT NULL PRIMARY KEY,
	fecha DATE NOT NULL,
	observaciones VARCHAR(100),
	nro_vendedor INTEGER NOT NULL,
	FOREIGN KEY (nro_vendedor) REFERENCES Vendedor (nro_vendedor) ON UPDATE CASCADE
);
-- VALORES -> FRANCO:
INSERT INTO Franco VALUES 
(0020, '2024-01-20', 'Descanso compensatorio acordado', 1),
(0021, '2024-03-26', 'Descanso semanal obligatorio', 2),
(0022, '2024-04-13', 'Día no laborable por rotación de turno', 3);

-- TABLA FECHA:
CREATE TABLE Fecha
(
	dia VARCHAR(100) NOT NULL PRIMARY KEY
);
-- VALORES -> FECHA:
INSERT INTO Fecha VALUES 
('Lunes'),
('Martes'),
('Miercoles'),
('Jueves'),
('Viernes');

-- TABLA STOCK:
CREATE TABLE Stock
(
	numero INTEGER NOT NULL,
	modelo VARCHAR(100) NOT NULL,
	color VARCHAR(100) NOT NULL,
	cantidad INTEGER NOT NULL,
	PRIMARY KEY (numero, modelo, color),
    FOREIGN KEY (numero) REFERENCES Talla (numero) ON UPDATE CASCADE,
    FOREIGN KEY (modelo, color) REFERENCES Zapato (modelo, color) ON UPDATE CASCADE
);
-- VALORES -> STOCK:
INSERT INTO Stock VALUES
(39, 'Zapatilla', 'Blanco', 50),
(38, 'Alpargata', 'Marrón', 25),
(37, 'Chancleta', 'Rosa', 30);

-- TABLA PROVEEDOR:
CREATE TABLE Proveedor
(
	cuit VARCHAR(100) NOT NULL PRIMARY KEY,
	direccion VARCHAR(100) NOT NULL,
	tfono_fijo INTEGER NOT NULL UNIQUE,
	razon_social VARCHAR(100) NOT NULL UNIQUE
);
-- VALORES -> PROVEEDOR:
INSERT INTO Proveedor VALUES
('33-45891234-5', 'Ruta 30 3005', 464765, 'Zapatitos & Co. S.C.'),
('30-12345678-5', 'Chiclana 203', 464893, 'Zapatillitas & Co. S.R.L.'),
('32-90876523-5', 'Humahuaca 43', 464234, 'Del Campo al Mundo S.A.');

-- TABLA PCEL (atributo multivaluado de PROVEEDOR):
CREATE TABLE PCel
(
	cuit VARCHAR(100) NOT NULL,
	celular BIGINT NOT NULL,
	PRIMARY KEY (cuit, celular),
    FOREIGN KEY (cuit) REFERENCES Proveedor (cuit) ON DELETE CASCADE
);
-- VALORES -> PCEL:
INSERT INTO PCel VALUES
('33-45891234-5', 3584017895),
('30-12345678-5', 3584649073),
('32-90876523-5', 3515824995);

-- TABLA (relación) VTA_ZAPATO:
CREATE TABLE Vta_Zapato
(
	numero INTEGER NOT NULL,
	modelo VARCHAR(100) NOT NULL,
	color VARCHAR(100) NOT NULL,
	cod_venta INTEGER NOT NULL,
	precio_vta DOUBLE NOT NULL,
	cantidad_vta INTEGER NOT NULL,
	PRIMARY KEY (numero, modelo, color, cod_venta),
	FOREIGN KEY (numero, modelo, color) REFERENCES Stock (numero, modelo, color) ON UPDATE CASCADE,
	FOREIGN KEY (cod_venta) REFERENCES Venta (cod_venta) ON UPDATE CASCADE
);
-- VALORES -> VTA_ZAPATO:
INSERT INTO Vta_Zapato VALUES
(39, 'Zapatilla', 'Blanco', 089, 24000, 5),
(38, 'Alpargata', 'Marrón', 090, 500, 2),
(37, 'Chancleta', 'Rosa', 091, 82350, 1);

-- TABLA (relación) PROVEE:
CREATE TABLE Provee
(
	cuit VARCHAR(100) NOT NULL, 
	modelo VARCHAR(100) NOT NULL,
	color VARCHAR(100) NOT NULL,
	PRIMARY KEY (cuit, modelo, color),
	FOREIGN KEY (cuit) REFERENCES Proveedor (cuit) ON UPDATE CASCADE,
	FOREIGN KEY (modelo, color) REFERENCES Zapato (modelo, color) ON UPDATE CASCADE
); 
-- VALORES -> PROVEE:
INSERT INTO Provee VALUES
('33-45891234-5', 'Zapatilla', 'Blanco'),
('30-12345678-5', 'Alpargata', 'Marrón'),
('32-90876523-5', 'Chancleta', 'Rosa');

-- TABLA (relación) TRABAJO:
CREATE TABLE Trabajo
(
	dni_vendedor INTEGER NOT NULL,
	dia VARCHAR(100) NOT NULL,
	hs_entrada INTEGER NOT NULL,
	hs_salida INTEGER NOT NULL,
	PRIMARY KEY (dni_vendedor, dia),
	FOREIGN KEY (dni_vendedor) REFERENCES Vendedor (dni_vendedor) ON UPDATE CASCADE,
	FOREIGN KEY (dia) REFERENCES Fecha (dia) ON UPDATE CASCADE
);
-- VALORES -> TRABAJO:
INSERT INTO Trabajo VALUES
(40789120, 'Lunes', 08, 12),
(23478029, 'Martes', 12, 16),
(43566778, 'Viernes', 16, 20);

-- TABLA TRIGGER:
CREATE TABLE Auditoria_Zapato
(
	modelo VARCHAR(100) NOT NULL,
	color VARCHAR(100) NOT NULL,
	fecha DATE NOT NULL,
	old_precio DOUBLE NOT NULL,
	new_precio DOUBLE NOT NULL,
	usuario VARCHAR(100) NOT NULL
);
-- TRIGGER:
DELIMITER $$
CREATE TRIGGER info_auditoria
	AFTER UPDATE ON Zapato
	FOR EACH ROW 
	BEGIN
		IF NOT (old.precio <=> new.precio) THEN
			INSERT INTO Auditoria_Zapato VALUES (OLD.modelo, OLD.color, CURRENT_DATE(), OLD.precio, NEW.precio, CURRENT_USER());
		END IF;
	END;
$$
DELIMITER ;