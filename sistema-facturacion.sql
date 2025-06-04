
-- DROP DATABASE IF EXISTS FacturacionDB; 

CREATE DATABASE IF NOT EXISTS FacturacionDB;
USE FacturacionDB;


-- Tabla clientes
CREATE TABLE Clientes (
    ClienteID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100),
    Apellido VARCHAR(100),
    Email VARCHAR(100),
    Direccion VARCHAR(100),
    Ciudad VARCHAR(50)
);

-- Tabla facturas
CREATE TABLE Facturas (
    FacturaID INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT,
    Fecha DATE,
    Monto DECIMAL(10, 2),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

-- Insertar clientes
INSERT INTO Clientes (Nombre, Apellido, Email, Direccion, Ciudad) VALUES
('Juan',  'Pérez', 'juan@example.com', 'Quito 19', 'Madrid'),
('Ana', ' Torres', 'ana@example.com', 'Canillejas 12', 'Madrid'),
('Pedro', 'Jose', 'pedro@example.com', 'Alabama 26', 'Toledo')
;

-- Insertar facturas

INSERT INTO Facturas (ClienteID, Fecha, Monto) VALUES
(1, '2025-05-01', 1000),
(1, '2025-05-15', 2300),
(2, '2025-05-20', 1500);

-- Calculo de IVA
-- Función para calcular el IVA (21%)
DELIMITER $$

CREATE FUNCTION CalcularIVA (monto DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN monto * 0.21;
END$$

DELIMITER ;

-- Procedure para reporte mensual

DROP PROCEDURE ReporteFacturacionMensual;

DELIMITER $$
CREATE PROCEDURE ReporteFacturacionMensual()
BEGIN
    SELECT 
        c.Nombre, c.Apellido, c.Email,
        DATE_FORMAT(f.Fecha, '%Y-%m') AS Mes,
        SUM(f.Monto) AS TotalFacturado
    FROM Facturas f
    JOIN Clientes c ON f.ClienteID = c.ClienteID
    GROUP BY c.Nombre, DATE_FORMAT(f.Fecha, '%Y-%m');
END$$

DELIMITER ;

-- Vista de reposrtes

CREATE OR REPLACE VIEW VistaFacturasConIVA AS
SELECT 
    f.FacturaID,
    c.Nombre,
    c.Apellido,
    c.Email,
    f.Fecha,
    f.Monto,
    CalcularIVA(f.Monto) AS IVA,
    f.Monto + CalcularIVA(f.Monto) AS TotalConIVA
FROM Facturas f
JOIN Clientes c ON f.ClienteID = c.ClienteID;

-- Ver la vista de facturacion

select * FROM VistaFacturasConIva;

SHOW CREATE VIEW Vista_Facturacion;

-- Muestro la vista

SHOW FULL TABLES IN FacturacionDB WHERE TABLE_TYPE = 'VIEW';

-- Ver vista facturacion con iva

SELECT * FROM VistaFacturasConIva;

-- verifiar si el procedure esta creado

SHOW PROCEDURE STATUS WHERE Db = 'FacturacionDB';


-- ejecutar el procedure

CALL ReporteFacturacionMensual();

-- Agreagr nueva columna a Clientes si es o no cliente activo

ALTER TABLE Clientes
ADD COLUMN activo BOOLEAN DEFAULT True;

UPDATE Clientes
SET activo TRUE;

-- Chequeae columna

SELECT nombre, ciudad, activo FROM Clientes;