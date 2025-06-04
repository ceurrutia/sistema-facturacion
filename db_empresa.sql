
-- DROP DATABASE IF EXISTS db_empresa;
CREATE DATABASE db_empresa;
USE db_empresa;


CREATE TABLE contactos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    apellido VARCHAR(100),
    email VARCHAR(100),
    mensaje VARCHAR(500)
);


INSERT INTO contactos(nombre, apellido, email, mensaje) VALUES
("Maria", "Perez", "mailmaria@g.com", "Hola, necesito más bicis"),
("Carlos", "Lopez", "carlos@g.com", "Devolver una de las bicis"),
("Alana", "Kudrow", "alana@g.com", "Perdi el ticke de compra"),
("nATALIA", "Sosa", "nat@g.com", ""),
("Anders", "Sanchez", "ands@g.com", "Bici con manubrio roto");

-- Tabla de auditoría
DROP TABLE IF EXISTS contactos_auditoria;

/***** CREAR TABLA PARA AUDITAR ******/

CREATE TABLE contactos_auditoria (
    id INT PRIMARY KEY AUTO_INCREMENT,
    contacto_id INT,
    nombre VARCHAR(50),
    apellido VARCHAR(100),
    email VARCHAR(100),
    mensaje VARCHAR(500),
    accion VARCHAR(10),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

select * from contactos;

-- TRIGGER 

DROP TRIGGER IF EXISTS contactos_aud;

DELIMITER //
CREATE TRIGGER guardar_contactos_eliminados
BEFORE DELETE ON contactos
FOR EACH ROW
BEGIN
    INSERT INTO contactos_auditoria (
        contacto_id, nombre, apellido, email, mensaje, accion
    )
    VALUES (
        OLD.id, OLD.nombre, OLD.apellido, OLD.email, OLD.mensaje, 'DELETE'
    );
END;
//
DELIMITER ;


DELETE FROM contactos WHERE id = 1;

-- Consulta auditoría
SELECT * FROM contactos_auditoria WHERE accion = 'DELETE';

-- TRIGGER PARA ALMACENAR CUANDO SE HACE UPDATE

DELIMITER //
CREATE TRIGGER guardar_contactos_actualizados
AFTER UPDATE ON contactos
FOR EACH ROW
BEGIN
    INSERT INTO contactos_auditoria (
        contacto_id, nombre, apellido, email, mensaje, accion
    )
    VALUES (
        NEW.id, NEW.nombre, NEW.apellido, NEW.email, NEW.mensaje, 'UPDATE'
    );
END //
DELIMITER ;

-- HACER UN UPDATE DE PRUEBA

UPDATE contactos
set nombre = "Natalia"
where nombre="nATALIA" and apellido="Sosa";


SELECT * FROM contactos_auditoria WHERE accion = 'UPDATE';

SHOW TRIGGERS LIKE 'contactos';

-- funcion que devuelve nombre completo de contacto

DELIMITER //
CREATE FUNCTION nombre_completo(p_id int)
returns varchar(50)
deterministic
BEGIN
DECLARE nombre_completo_resultado VARCHAR (250);

		SELECT concat(nombre, ' ', apellido)
        into nombre_completo_resultado 
        from contactos
        where id=p_id;
        return nombre_completo_resultado;
END //
DELIMITER ;

select nombre_completo(2);


